# Bootstraps my NixOS configuration per host.
#
# Import it from /etc/nixos/configuration.nix with:
#
#     import /etc/nixfiles "host";
#

host:
{ ... }: {
  imports = [ ./modules "${./hosts}/${host}" ];
}
