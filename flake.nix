{
  description = "Rust module for Conch";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    conch = {
      url = "github:mibmo/conch/modularity";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ ... }:
    {
      conchModules = rec {
        default = rust;
        rust = import ./module.nix inputs;
      };
    };
}
