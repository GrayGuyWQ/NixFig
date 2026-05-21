# ~/NixFig/flakes/rust/flake.nix

{
  description = "Rust dev env module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    let
   
      overlays = [
        rust-overlay.overlays.default
      ];
    in 
    {
    
      nixosModules.default = {config, pkgs, ...}: 
      {
        _rustPkgs = import pkgs.path {
          inherit (pkgs) system;
          inherit overlays; 
      };

      home.packages = [
        config._rustPkgs.rust-bin.stable.latest.default
        config._rustPkgs.rust
      ];
      
        home.sessionVariables = {
          RUST_SRC_PATH = "{config._rustPkgs.rust-bin.stable.latest.default}/lib/rustlib/src/rust/library";
        };
    };
  };
}
          

