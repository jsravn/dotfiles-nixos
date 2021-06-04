{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-paperwm";
  version = "edcb20da4138cbe3d892083bcbdb9e8d6d7747af";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = version;
    sha256 = "0dbz6bsdzi056al0wmznznzfl63xhhavpc5s2xkx0f4aj477gqpl";
  };

  uuid = "paperwm@hedning:matrix.org";

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Tiled scrollable window management for Gnome Shell";
    homepage = "https://github.com/paperwm/PaperWM";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hedning zowoq ];
  };
}
