{
  config,
  pkgs,
  lib,
  ...
}:

{
  xdg.configFile."matugen".source =
    config.lib.file.mkOutOfStoreSymlink "/home/gray/NixFig/config/programs/matugen";
}
