# Helix editor configuration
{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "base16_transparent";
      keys = { insert = { C-c = "normal_mode"; }; };
    };
  };
}
