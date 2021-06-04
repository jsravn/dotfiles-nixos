{ stdenv
, fetchFromGitHub
, glib
, gettext
, lib
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-switcher";
  version = "2021-06-04";

  src = fetchFromGitHub {
    owner = "daniellandau";
    repo = "switcher";
    rev = "427171cfd37d657801d48539e1f35645d14fcd7e";
    sha256 = "0cc0njx1g06dfrzs3pv12v59ix5bzp2r6kvp939zwnip1rzm9i9w";
  };

  nativeBuildInputs = [
    glib
    gettext
  ];

  uuid = "switcher@landau.fi";

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  meta = with lib; {
    description = "A windows switcher and app launcher for Gnome Shell";
    homepage = "https://github.com/daniellandau/switcher";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jsravn ];
  };
}
