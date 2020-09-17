{ stdenv, lib, fetchFromGitHub, cmake, nasm, pkg-config, coreutils
, gtk3, glib, ffmpeg_2, alsaLib, libmad, libogg, libvorbis
, glew, libpulseaudio, libva, libXtst, udev
}:

stdenv.mkDerivation rec {
  pname = "stepmania";
  version = "5_1-new";

  src = fetchFromGitHub {
    owner = "stepmania";
    repo  = "stepmania";
    rev   = "1c869edab5eba6d6975c137642cd64fef237eea9";
    sha256 = "1lqsd954hy3r7w49abiqxagf7c94rjins6dz1w7jf2j55nbw5z5q";
  };

  nativeBuildInputs = [ cmake nasm pkg-config coreutils ];

  buildInputs = [
    gtk3 glib ffmpeg_2 alsaLib libmad libogg libvorbis
    glew libpulseaudio libva libXtst udev
  ];

  # Patch the git revision into the version, so we get the correct version string.
  # Used by themes such as Simply Love.
  patches = [ ./stepmania.patch ];

  cmakeFlags = [
    "-DWITH_SYSTEM_FFMPEG=1"
  ];

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/stepmania-5.1/stepmania $out/bin/stepmania
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.stepmania.com/";
    description = "Free dance and rhythm game for Windows, Mac, and Linux";
    platforms = platforms.linux;
    license = licenses.mit; # expat version
    maintainers = [ ];
  };
}
