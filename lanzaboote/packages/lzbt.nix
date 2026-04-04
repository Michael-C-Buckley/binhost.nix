{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs.stdenv) mkDerivation hostPlatform;

  binPath = with pkgs; [
    binutils-unwrapped
    sbsigntool
  ];
  runtimeLibPath = pkgs.lib.makeLibraryPath (
    with pkgs; [
      glibc
      (lib.getLib stdenv.cc.cc)
    ]
  );

  stub = pkgs.callPackage ./stub.nix {inherit pkgs;};
in
  mkDerivation {
    pname = "lzbt-systemd-bin";
    version = "v1.0.0";
    src = ./${hostPlatform.system}/lzbt-v1.0.0.tar.gz;

    nativeBuildInputs = [
      pkgs.patchelf
      pkgs.makeBinaryWrapper
    ];

    propagatedBuildInputs = [
      stub
      pkgs.sbsigntool
    ];

    dontBuild = true;
    dontConfigure = true;
    dontUnpack = true;
    dontCheck = true;

    installPhase =
      # bash
      ''
        mkdir -p $out
        tar -xzf $src -C $out
        runHook postInstall
      '';

    postInstall =
      # bash
      ''
        chmod u+w $out/bin/lzbt-systemd
        patchelf --set-interpreter ${pkgs.stdenv.cc.bintools.dynamicLinker} \
          --set-rpath ${runtimeLibPath} \
          $out/bin/lzbt-systemd

        makeWrapper $out/bin/lzbt-systemd $out/bin/lzbt \
          --set PATH ${pkgs.lib.makeBinPath binPath} \
          --set LANZABOOTE_STUB ${stub}/bin/lanzaboote_stub.efi
      '';

    meta.mainProgram = "lzbt";
  }
