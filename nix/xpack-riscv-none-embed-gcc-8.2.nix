{ lib
, stdenv
, fetchurl
, runtimeShell
# , xpack_toolchain_version ? "8.3.0-2.3"
# , xpack_toolchain_hash ? "sha256-cI0Mtf8S61rQcBU1lMT3dxzYbUtnIad7I/j+aVyPlAI="
# , ext ? "tar.gz"
    , xpack_toolchain_version ? "8.2.0-3.1"
, xpack_toolchain_hash ? "sha256-PUD6tQ662EJP+FdI8l0uruUPhqXVIiq9ekWi5JDx5PU="
, ext ? "tgz"
}:

stdenv.mkDerivation rec {
  pname = "gcc-risc-v-elf";
  version = xpack_toolchain_version;

  src = fetchurl {
    url = "https://github.com/xpack-dev-tools/riscv-none-embed-gcc-xpack/releases/download/v${version}/xpack-riscv-none-embed-gcc-${version}-linux-x64.${ext}";
    hash = xpack_toolchain_hash;
  };

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/
    cp -r riscv-none-embed-gcc/8.2.0-3.1/* $out
  '';

  preFixup = ''
    find $out -type f | while read f; do
      patchelf "$f" > /dev/null 2>&1 || continue
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f" || true
    done
  '';

  meta = {
  };
}
