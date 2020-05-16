# nixfiles

My NixOS configuration.

# Installing

From the NixOS install image use parted or similar to create the destination partition and filesystem. Then mount the root
to `/mnt` and the ESP partition to `/mnt/boot` (for UEFI systems).

``` sh
sudo -i
nix-env -iA nixos.git nixos.gnumake
git clone https://github.com/jsravn/nixfiles.git /mnt/etc/nixfiles
cd /mnt/etc/nixfiles
HOST=myhost make install
```

After rebooting, use `make move-nixfiles` to move the config into `$HOME/.nixfiles`.

## Tips

To fix the resolution on the install image:

``` sh
sudo -i
kill $(pidof kscreen_backend_launcher)
xrandr --output <Output> --mode <widthxheight>
```

# Credit

While I built this NixOS configuration for my own needs, many things were borrowed/inspired from
https://github.com/hlissner/dotfiles/ as a starting point.

# TODO
- PragmataPro
- Waybar
- Redshift config
