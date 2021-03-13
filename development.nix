{ config, pkgs, ... }:

let
clj2nix = pkgs.callPackage (pkgs.fetchFromGitHub {
    owner = "WhittlesJr";
    repo = "clj2nix";
    rev = "f379543d7d8f3bf8f2f2257ee6f91011664c052a";
    sha256 = "1cbdphk52h069zjk9q9h1dqp34g4n376g9b37zjr66a70p073f8f";
  }) {};

  python = pkgs.python37.withPackages (ps: with ps; [
  ]);

in
{
  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
    winetricks

    inotify-tools

    # Clojure
    clj2nix
    clojure
    leiningen
    maven

    # C/C++
    cmake
    gnumake
    gcc
    boost
    pkgconfig

    # Markdown
    pandoc
    lmodern

    # Golang
    go2nix
    dep2nix
    go
    dep
    glide

  ] ++ [ python ];
}
