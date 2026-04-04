{pkgs, ...}: {
  imports = [
    ./lanzaboote.nix
  ];

  boot.lanzaboote.package = import ../packages/lzbt.nix {inherit pkgs;};
}
