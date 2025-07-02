{ config, pkgs, ... }:

{ 
  home.username = "gray";
  home.homeDirectory = "/home/gray";

  home.packages = with pkgs; [
    ];

  programs.neovim.enable = true;

  home.stateVersion = "25.05";
}
