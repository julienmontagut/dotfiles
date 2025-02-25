{ pkgs, lib, config, ... }:

{
  home.packages = with pkgs;
    [
      (pkgs.writeShellScriptBin "claude" ''
        ${pkgs.nodejs}/bin/node ${config.home.homeDirectory}/.npm-global/bin/claude "$@"
      '')
    ];

  home.sessionPath = [ "$HOME/.npm-global/bin" ];
  home.sessionVariables = { NPM_CONFIG_PREFIX = "$HOME/.npm-global"; };

  home.activation = {
    installClaudeCode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if ! [ -d "$HOME/.npm-global" ]; then
        $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "$HOME/.npm-global"
      fi

      $DRY_RUN_CMD ${pkgs.nodejs}/bin/npm config set prefix "$HOME/.npm-global"

      # Check if claude-code is installed, if not install it
      if ! [ -e "$HOME/.npm-global/bin/claude" ]; then
        $DRY_RUN_CMD ${pkgs.nodejs}/bin/npm install -g @anthropic-ai/claude-code
      else
        # Check for updates if already installed
        $DRY_RUN_CMD ${pkgs.nodejs}/bin/npm update -g @anthropic-ai/claude-code
      fi
    '';
  };
}
