let
  pkgs = import <nixpkgs> { config.allowUnfree = true; };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    gcc
    clang
    bear
    zip
    gnumake
    gdb
    cudatoolkit
    linuxPackages.nvidia_x11
    libGLU libGL
    xorg.libXi xorg.libXmu freeglut
    xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib
    ncurses5 stdenv.cc binutils
    openmpi
    gnuplot
  ];
  shellHook = ''
      export CUDA_PATH=${pkgs.cudatoolkit}
      export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib:${pkgs.cudatoolkit}/extras/CUPTI/lib64
      export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
      export EXTRA_CCFLAGS="-I/usr/include"
  '';
}
