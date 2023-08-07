self: super: {
  linuxPackages_latest = super.linuxPackages_latest.extend (lpself: lpsuper: {
    rtl8821au = lpsuper.rtl8821au.overrideAttrs (old: {
      src = super.fetchFromGitHub {
        owner = "morrownr";
        repo = "8821au-20210708";
        rev = "a133274";
        sha256 = "sha256-xn2cmbtqQhLM9qLCEvVhCuoCa7y8LM4sevPqv3a6pBw=";
      };
    });
  });
}
