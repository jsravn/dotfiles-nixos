{ stdenv
, fetchFromGitHub
, lib
, alsaLib
, ffmpeg
, libpulseaudio
, libsndfile
, ladspa-sdk }:

stdenv.mkDerivation rec {
  pname = "dsp";
  version = "v1.8";

  src = fetchFromGitHub {
    owner = "bcm0";
    repo = "dsp";
    rev = "${version}";
    sha256 = "0cc0njx1g06dfrzs3pv12v59ix5bzp2r6kvp939zwnip1rzm9i9w";
  };

  buildInputs = [
    alsaLib
    ffmpeg
    libpulseaudio
    libsndfile
    ladspa-sdk
  ];
}
