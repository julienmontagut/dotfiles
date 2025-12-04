{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  xdg.configFile."nvim" = {
    source = ../config/nvim;
    onChange = ''
      mkdir -p ${config.xdg.dataHome}/nvim
      cp -f ${config.xdg.configHome}/nvim/lazy-lock.json ${config.xdg.dataHome}/nvim/lazy-lock.json
      '';
  };
}
