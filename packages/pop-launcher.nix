{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "pop-launcher";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "launcher";
    rev = "${version}";
    sha256 = "DHmp3kzBgbyxRe0TjER/CAqyUmD9LeRqAFQ9apQDzfk=";
  };

  cargoSha256 = "DHmp3kzBgbyxRe0TjER/CAqyUmD9LeRqAFQ9apQDzfk=";

  meta = with lib; {
    description = "Pop-OS Launcher";
    homepage = "https://github.com/pop-os/launcher";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
