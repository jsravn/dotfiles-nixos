{ stdenv, lib, glib, makeWrapper, fetchFromGitHub }:

let
  baseName = "notify-send.sh";
  version = "1.1";
in stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "vlevit";
    repo = "${baseName}";
    rev = "v${version}";
    sha256 = "1ma8hnk1g59a9qfhyzgqzypqcnm5h7gcwmfp1j7qm9l8hv0a84i8";
  };

  meta = {
    description = "notify-send.sh";
    homepage = "https://github.com/vlevit/notify-send.sh";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ glib ];

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/*.sh $out/bin/
    for f in $out/bin/*.sh; do
        wrapProgram "$f" --prefix PATH : "${glib}/bin"
    done
  '';
}
