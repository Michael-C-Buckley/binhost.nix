{pkgs ? import <nixpkgs> {}}:
pkgs.callPackage ./packages/sops-install-secrets.nix {inherit pkgs;}
