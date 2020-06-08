{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, wayland-protocols
, pipewire, wayland, elogind, systemd, libdrm, unstable }:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-wlr";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "12k92h9dmn1fyn8nzxk69cyv0gnb7g9gj7a66mw5dcl5zqnl07nc";
  };

  nativeBuildInputs = [ meson ninja pkgconfig unstable.wayland-protocols ];
  buildInputs = [ unstable.pipewire unstable.wayland unstable.elogind systemd unstable.libdrm ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/emersion/xdg-desktop-portal-wlr";
    description = "xdg-desktop-portal backend for wlroots";
    maintainers = with maintainers; [ minijackson ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
