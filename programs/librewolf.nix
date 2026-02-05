{ pkgs, ... }:

{
  programs.librewolf = {
    enable = false;
    settings = {
      "identity.fxaccounts.enabled" = true;
    };
  };
}
