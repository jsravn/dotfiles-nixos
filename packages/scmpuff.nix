{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "scmpuff";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mroth";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zrzzcs0i13pfwcqh8qb0sji54vh37rdr7qasg57y56cqpx16vl3";
  };

  vendorSha256 = null;
  modSha256 = "1zsj5nhxa33v2dfq9s6r7jrbx7bhchv4daixh49mzkmd4y0fbm1p";

  meta = {
    description = "git shortcuts";
    homepage = "https://github.com/mroth/scmpuff";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
