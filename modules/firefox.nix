{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    # settings = { "identity.fxaccounts.enabled" = true; };
  };
}
