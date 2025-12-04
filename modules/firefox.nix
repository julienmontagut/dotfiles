{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    # settings = { "identity.fxaccounts.enabled" = true; };
  };
}
