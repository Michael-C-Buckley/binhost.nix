{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs.stdenv) mkDerivation hostPlatform;

  runtimeLibPath = pkgs.lib.makeLibraryPath (
    with pkgs; [
      glibc
    ]
  );
in
  mkDerivation {
    pname = "sops-install-secrets";
    version = "0.0.1";
    src = ./${hostPlatform.system}/sops-install-secrets;

    nativeBuildInputs = [
      pkgs.patchelf
    ];

    dontBuild = true;
    dontConfigure = true;
    dontUnpack = true;
    dontCheck = true;

    installPhase =
      # bash
      ''
        mkdir -p $out/bin
        install -m755 $src $out/bin/sops-install-secrets
        runHook postInstall
      '';

    postInstall =
      # bash
      ''
        patchelf --set-interpreter ${pkgs.stdenv.cc.bintools.dynamicLinker} \
          --set-rpath ${runtimeLibPath} \
          $out/bin/sops-install-secrets
      '';

    meta.mainProgram = "sops-install-secrets";
  }
