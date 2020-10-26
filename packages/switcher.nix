{ stdenv
, fetchFromGitHub
, glib
, gettext
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-switcher";
  version = "2020-10-26";

  src = fetchFromGitHub {
    owner = "daniellandau";
    repo = "switcher";
    rev = "afdf9fc81baa53a44637230a1ff9d547f3074765";
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

  meta = with stdenv.lib; {
    description = "A windows switcher and app launcher for Gnome Shell";
    homepage = "https://github.com/daniellandau/switcher";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jsravn ];
  };
}
