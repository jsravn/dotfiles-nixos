{ alsaLib
, alsaUtils
, autoPatchelfHook
, cifs-utils
, fetchurl
, ffmpeg
, freetype
, lib
, makeWrapper
, stdenv
, zlib
}: stdenv.mkDerivation rec {
  name = "roon-bridge";
  version = "100700571";

  src = fetchurl {
    url = "http://download.roonlabs.com/builds/RoonBridge_linuxx64.tar.bz2";
    sha256 = "6a1772d3f4c13b231f0ade154e47034d9180166c10253d8abd9b8cb45700637c";
  };

  buildInputs = [
    alsaLib
    alsaUtils
    cifs-utils
    ffmpeg
    freetype
    zlib
  ];

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    mv * $out
    runHook postInstall
  '';

  postFixup =
    let
      linkFix = bin: ''
        sed -i '/ulimit/d' ${bin}
        sed -i '/ln -sf/d' ${bin}
        ln -sf $out/RoonMono/bin/mono-sgen $out/RoonMono/bin/${builtins.baseNameOf bin}
      '';
      wrapFix = bin: ''
        wrapProgram ${bin} --prefix PATH : ${lib.makeBinPath [ alsaUtils cifs-utils ffmpeg ]}
      '';
    in
    ''
      ${linkFix "$out/Bridge/RAATServer"}
      ${linkFix "$out/Bridge/RoonBridgeHelper"}
      ${linkFix "$out/Bridge/RoonBridge"}
      sed -i '/which avconv/c\    WHICH_AVCONV=1' $out/check.sh
      sed -i '/^check_ulimit/d' $out/check.sh
      ${wrapFix "$out/check.sh"}
      ${wrapFix "$out/start.sh"}
    '';

  meta = with lib; {
    description = "The music player for music lovers";
    homepage = "https://roonlabs.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ jsravn ];
    platforms = platforms.linux;
  };
}
