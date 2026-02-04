{ pkgs, ... }:

{
  programs.firefox = {
    enable = false;
    # settings = { "identity.fxaccounts.enabled" = true; };
  };
}
