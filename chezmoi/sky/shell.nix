let
  pkgs = import <nixpkgs> {};
  my-python = pkgs.python3.withPackages (ps: with ps; [ boto3 black kubernetes ]);
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    gcc
    gnumake
    ansible
    go
    adoptopenjdk-bin
    buildkit
    kustomize
    gradle
    jq
    keepassx2
    mkcert
    my-python
    protobuf
    prometheus
    openssl
    zip
    terraform
    python-language-server
  ];
}
