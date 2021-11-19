let
  pkgs = import <nixos> {};
  unstable = import <nixpkgs-unstable> {};
  my-python = pkgs.python3.withPackages (ps: with ps; [ boto3 black kubernetes j2cli ]);
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    gcc
    gnumake
    ansible
    unstable.go_1_17
    jdk11
    buildkit
    unstable.kustomize
    gradle
    jq
    keepassx2
    mkcert
    my-python
    protobuf
    prometheus
    openssl
    zip
    unstable.terraform
    python-language-server
    unstable.google-cloud-sdk
    unstable.tektoncd-cli
    unstable.stern
  ];
  shellHook = ''
    export JAVA_HOME=${pkgs.jdk11}/lib/openjdk
  '';
}
