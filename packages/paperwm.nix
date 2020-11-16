{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-paperwm";
  version = "ee0a3eaee414fc9e8e708ed961a0738f54eed023";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = version;
    sha256 = "1qy5zkl0ki71b19713ns8n8jvbg4bc0svppklc68wpm5pj6zcp90";
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
