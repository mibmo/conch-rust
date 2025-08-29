inputs:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.rust;

  inherit (lib) types;
  inherit (lib.attrsets) attrValues;
  inherit (lib.options) mkEnableOption mkOption;
in
{
  options.rust = {
    enable = mkEnableOption "rust development environment";
    channel = mkOption {
      type =
        with types;
        enum [
          "stable"
          "beta"
          "nightly"
        ];
      default = "stable";
      description = ''
        release channel to use.
      '';
    };
    profile = mkOption {
      type =
        with types;
        enum [
          "minimal"
          "default"
          "complete"
        ];
      default = "default";
      description = ''
        component set
      '';
    };
    targets = mkOption {
      type =
        with types;
        listOf (enum (attrValues (import "${inputs.rust-overlay}/manifests/targets.nix")));
      default = [ ];
      description = ''
        targets to support cross compiling to.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

    shell.packages =
      let
        rust = pkgs.rust-bin.${cfg.channel}.latest.${cfg.profile}.override {
          inherit (cfg) targets;
        };
      in
      [ rust ];
  };
}
