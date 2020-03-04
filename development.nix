{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Clojure
    clojure
    leiningen
    maven

    # C/C++
    cmake
    gnumake
    gcc
    boost
    pkgconfig

    # Python
    python
    python3

    # Markdown
    pandoc
    lmodern

    # Golang
    go2nix
    dep2nix
    go
    dep
    glide
  ];
}
