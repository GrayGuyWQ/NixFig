{ config, ... }:

{
  xdg.configFile."kitty".source =
    config.lib.file.mkOutOfStoreSymlink "~/NixFig/config/programs/kitty";
}
