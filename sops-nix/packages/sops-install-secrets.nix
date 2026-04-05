{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation {
  pname = "sops-install-secrets";
  version = "0.0.1";

  src = ./${pkgs.stdenv.hostPlatform.system}/sops-install-secrets;

  nativeBuildInputs = [
    pkgs.autoPatchelfHook
    pkgs.makeWrapper
  ];

  buildInputs = [pkgs.glibc];

  dontBuild = true;
  dontConfigure = true;
  dontUnpack = true;
  dontCheck = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m755 $src $out/bin/.sops-install-secrets-unwrapped
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/bin/.sops-install-secrets-unwrapped $out/bin/sops-install-secrets \
      --set LD_LIBRARY_PATH ${pkgs.lib.makeLibraryPath [pkgs.glibc]}
  '';

  meta.mainProgram = "sops-install-secrets";
}
