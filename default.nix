# Bootstraps my configuration per host.
#
# Import it from /etc/nixos/configuration.nix with:
#
#     import /etc/nixfiles "host";
#
# Or on darwin, import from ~/.nixpkgs/darwin-configuration.nix:
#
#     import ../.dotfiles "host";
#
host:
{ ... }: {
  imports = [ ./modules "${./hosts}/${host}" ];
}
