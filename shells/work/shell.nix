{ pkgs ? import <nixpkgs> { } 
}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    awscli
    kubectl
    dbeaver
    lens
  ];
}