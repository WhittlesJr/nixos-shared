{ config, lib, pkgs, ... }:
let
  cfg = config.my.role.development;
  anyDevelopment = cfg.nix || cfg.clojure || cfg.python;
in
with lib;
{
  options.my = {
    role.development.nix = mkEnableOption "Developing nix / NixOS packages";
    role.development.clojure = mkEnableOption "Developing Clojure";
    role.development.python = mkEnableOption "Developing Python";
  };

  config = mkMerge [
    # Common
    (mkIf anyDevelopment {
      environment.systemPackages = with pkgs; [
        patchutils
        inotify-tools
        gnumake
      ];
    })

    # Nix / NixOS
    (mkIf cfg.nix {
      environment.systemPackages = with pkgs; [
        nix-index
        nixpkgs-review
        nix-prefetch
        nix-prefetch-git
      ];
    })

    # Clojure
    (mkIf cfg.clojure
      (let
        clj2nix = pkgs.callPackage (pkgs.fetchFromGitHub {
          owner = "WhittlesJr";
          repo = "clj2nix";
          rev = "f379543d7d8f3bf8f2f2257ee6f91011664c052a";
          sha256 = "1cbdphk52h069zjk9q9h1dqp34g4n376g9b37zjr66a70p073f8f";
        }) {};
      in
        {
          environment.systemPackages = with pkgs; [
            clj2nix
            clojure
            leiningen
            maven
            clj-kondo
          ];
        }))

    # Python
    (mkIf cfg.python
      (let
        python = pkgs.python3.withPackages (ps: with ps; [
        ]);
      in
        {
          environment.systemPackages = with pkgs; [
            python
          ];
        }))
  ];
}
