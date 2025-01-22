# Firefox browser configuration
{ pkgs, ... }:

let
  # Common base settings for all profiles
  commonSettings = {
    "browser.search.defaultenginename" = "DuckDuckGo";
    "browser.search.order.1" = "DuckDuckGo";
    "extensions.pocket.enabled" = false;
    "extensions.autoDisableScopes" = 0;
    "extensions.getAddons.showPanes" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "browser.startup.page" = 3;
    "browser.startup.homepage" = "about:blank";
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "browser.translations.enable" = false;
    "browser.warnOnQuit" = false;
    "browser.warnOnQuitShortcut" = false;
  };

  # Common search configuration
  search = {
    default = "DuckDuckGo";
    order = [ "DuckDuckGo" ];
  };
in {
  # On nix-darwin `programs.firefox` is not available system-wide
  # TODO: On linux ensure firefox or librewolf is configured system-wide
  programs.firefox = {
    enable = true;
    package = null;
    profiles = {
      home = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          # icloud-passwords
          proton-pass
          ublock-origin
        ];
        search = search;
        settings = commonSettings;
      };
      work = {
        id = 1;
        search = search;
        settings = commonSettings;
      };
    };
  };
}
