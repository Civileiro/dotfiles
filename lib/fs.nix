lib:
with builtins;
with lib; {
  readDirNames = dir: filter (n: !hasPrefix "_" n) (attrNames (readDir dir));
}
