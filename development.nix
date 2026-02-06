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

        # Helper to create babashka commands from a source repo
        makeBabashkaCmd = src: name: module: pkgs.writeShellScriptBin name ''
          exec ${pkgs.babashka}/bin/bb --config ${src}/bb.edn -m ${module} "$@"
        '';

        # clojure-mcp-light tools for LLM nREPL integration
        clojure-mcp-light-src = pkgs.fetchFromGitHub {
          owner = "bhauman";
          repo = "clojure-mcp-light";
          rev = "v0.2.1";
          hash = "sha256-h8eX+HRPQ74hO5Ql5wz9znOoMAY2nncrgXoE+Nk+J54=";
        };
        mkClojureMcpCmd = makeBabashkaCmd clojure-mcp-light-src;
        clj-nrepl-eval = mkClojureMcpCmd "clj-nrepl-eval" "clojure-mcp-light.nrepl-eval";
        clj-paren-repair = mkClojureMcpCmd "clj-paren-repair" "clojure-mcp-light.paren-repair";

        # Invoker - zero-config CLI/HTTP/REPL interface for Clojure
        invoker-src = let
          rev = "18d00d8a85b2ed031c309ab2d642ce51de76edf5";
          tag = "v0.3.6";
          shortSha = builtins.substring 0 7 rev;
          src = pkgs.fetchFromGitHub {
            owner = "filipesilva";
            repo = "invoker";
            inherit rev;
            hash = "sha256-rnvGgrAUhvdT0kHSK+qLL2VZjMP6XRAUwhxuIW/Gexo=";
          };
        # Patch to hardcode git SHA instead of shelling out at runtime
        in pkgs.runCommand "invoker-patched" {} ''
          cp -r ${src} $out
          chmod -R u+w $out
          substituteInPlace $out/src/invoker/utils.clj \
            --replace-fail \
              'sha (str/trim (:out (process/sh opts "git rev-parse HEAD")))' \
              'sha "${rev}"' \
            --replace-fail \
              'out (str/trim (:out (process/sh opts "git describe --tags --dirty --always --long")))' \
              'out "${tag}-0-g${shortSha}"'
        '';
        nvk = makeBabashkaCmd invoker-src "nvk" "invoker.nvk";
      in
        {
          environment.systemPackages = with pkgs; [
            clj2nix
            clojure
            leiningen
            maven
            clj-kondo
            babashka
            clj-nrepl-eval
            clj-paren-repair
            nvk
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
