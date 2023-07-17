{ lib, ...}:
let
  inherit (builtins) readDir pathExists baseNameOf isString;
  inherit (lib) id hasPrefix hasSuffix removeSuffix nameValuePair attrValues mapAttrs' filterAttrs collect;
in
rec {

  # mapModulesByType :: (bool -> dir -> a) -> dir -> {a}
  # Apply a function to every .nix file and sub-directory in a directory,
  # the function receives a boolean that represents if the file is regular,
  # files with a "_" prefix and null results are filtered
  mapNixFiles = fn: dir:
    filterAttrs
      (name: value: value != null && !(hasPrefix "_" name))
      (mapAttrs'
        (name: file_type:
          let path = "${dir}/${name}"; in
          if file_type == "regular" && hasSuffix ".nix" name
            then nameValuePair (removeSuffix ".nix" name) (fn true path)
          else if file_type == "directory"
            then nameValuePair name (fn false path)
            else nameValuePair "" null)
        (readDir dir));

  # mapModules :: (dir -> a) -> dir -> {a}
  # Apply a function to every non-default module in a directory
  # and to every sub-directory with a default module,
  # files with a "_" prefix and null results are filtered
  mapModules = fn:
    mapNixFiles 
      (regular: path:
        if baseNameOf path == "default.nix"
          then null
        else if regular
          then fn path
        else if pathExists "${path}/default.nix"
          then fn path
          else null);

  # mapModules :: (dir -> a) -> dir -> [a]
  # Apply a function to every non-default module in a directory
  # and every default module in sub-directories
  mapModules' = fn: dir: attrValues (mapModules fn dir);

  # mapModules :: (dir -> a) -> dir -> {a}
  # Apply a function to every module in a directory
  # and sub-directories recursively
  mapModulesRec = fn:
    mapNixFiles 
      (regular:
        if regular
          then fn
          else mapModulesRec fn);

  # mapModules :: (dir -> a) -> dir -> [a]
  # Apply a function to every module in a directory
  # and sub-directories recursively
  mapModulesRec' = fn: dir:
    map fn (collect isString (mapModulesRec id dir));
    
}
