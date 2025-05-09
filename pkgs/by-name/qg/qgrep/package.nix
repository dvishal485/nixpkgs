{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "qgrep";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "qgrep";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-TeXOzfb1Nu6hz9l6dXGZY+xboscPapKm0Z264hv1Aww=";
  };

  patches = [
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/zeux/qgrep/commit/8810ab153ec59717a5d7537b3e7812c01cd80848.patch";
      hash = "sha256-lCMvpuLZluT6Rw8RFZ2uY9bffPBoq6sRVWYLUmeXfOg=";
    })
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-Wno-error=unused-command-line-argument"
      "-Wno-error=unqualified-std-cast-call"
    ]
  );

  installPhase = ''
    runHook preInstall

    install -Dm755 qgrep $out/bin/qgrep

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fast regular expression grep for source code with incremental index updates";
    mainProgram = "qgrep";
    homepage = "https://github.com/zeux/qgrep";
    license = licenses.mit;
    maintainers = [ maintainers.yrashk ];
    platforms = platforms.all;
  };
}
