{ config, lib, ... }:

{
  xdg.configFile."rofi/config.rasi".source =
    config.lib.file.mkOutOfStoreSymlink "~/NixFig/config/programs/rofi/config.rasi";
}
