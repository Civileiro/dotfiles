self: super: {
  catppuccin-sddm = super.libsForQt5.callPackage
    ({ stdenvNoCC, lib, fetchFromGitHub, qtgraphicaleffects, flavour ? "mocha" }:

      let
        pname = "catppuccin-sddm";
        validVariants = [ "latte" "frappe" "macchiato" "mocha" ];
      in lib.checkListOfEnum "${pname}: color variant" validVariants [ flavour ]

      stdenvNoCC.mkDerivation {
        inherit pname;
        version = "overlay";

        src = fetchFromGitHub {
          owner = "catppuccin";
          repo = "sddm";
          rev = "7fc67d1027cdb7f4d833c5d23a8c34a0029b0661";
          hash = "sha256-SjYwyUvvx/ageqVH5MmYmHNRKNvvnF3DYMJ/f2/L+Go=";
        };

        propagatedUserEnvPkgs = [ qtgraphicaleffects ];

        installPhase = ''
          runHook preInstall
          mkdir -p $out/share/sddm/themes
          mv src/catppuccin-${flavour} $out/share/sddm/themes
          runHook postInstall
        '';

        meta = with lib; {
          description = "Soothing pastel theme for SDDM";
          homepage = "https://github.com/catppuccin/sddm";
          platforms = platforms.linux;
        };
      }) { };
}
