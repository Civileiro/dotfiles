{ pkgs ? import <nixpkgs> { 
  config = {
    allowUnfree = true;
  };
} 
}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    awscli
    kubectl
    dbeaver
    lens
    google-chrome
  ];
}