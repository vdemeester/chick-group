{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:
rec {
  snazy = rustPlatform.buildRustPackage rec {
    pname = "snazy";
    version = "0.52.1";

    src = fetchFromGitHub {
      owner = "chmouel";
      repo = "snazy";
      rev = "${version}";
      hash = "sha256-OoUu42vRe4wPaunb2vJ9ITd0Q76pBI/yC8FI0J+J+ts=";
    };

    cargoHash = "sha256-gUeKZNSo/zJ4Nqy4Fpk5JuvFylGBlKJu+Nw9XWXVx0g=";

    buildInputs = lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

    meta = with lib; {
      description = "a snazzy json log viewer (with one z)";
      homepage = "https://github.com/chmouel/snazy";
      license = with licenses; [ mit ];
    };
  };
}
