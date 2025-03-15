{ pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    nodejs
    (pkgs.writeShellScriptBin "claude" ''
      ${pkgs.nodejs}/bin/node ${config.home.homeDirectory}/.npm-global/bin/claude "$@"
    '')
  ];

  home.sessionPath = [ "$HOME/.npm-global/bin" ];
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    NODE = "${pkgs.nodejs}/bin/node";
  };

  home.activation = {
    installClaudeCode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Ensure directories exist
      $DRY_RUN_CMD mkdir -p "$HOME/.npm-global/bin"
      $DRY_RUN_CMD mkdir -p "$HOME/.npm-global/lib/node_modules"

      # Create a symlink to node
      $DRY_RUN_CMD ln -sf "${pkgs.nodejs}/bin/node" "$HOME/.npm-global/bin/node"

      # Setup minimal PATH for npm operations
      NODE_BIN="${pkgs.nodejs}/bin"
      NPM_BIN="$HOME/.npm-global/bin"
      MINIMAL_PATH="$NODE_BIN:$NPM_BIN"
      export NODE="$NODE_BIN/node"

      # Configure npm
      $DRY_RUN_CMD $NODE_BIN/npm config set prefix "$HOME/.npm-global"

      # Install or skip update
      if ! [ -e "$HOME/.npm-global/bin/claude" ]; then
        echo "Installing @anthropic-ai/claude-code..."
        if ! $DRY_RUN_CMD env PATH="$MINIMAL_PATH" $NODE_BIN/npm install -g @anthropic-ai/claude-code; then
          echo "Failed to install claude-code, continuing..."
        fi
      fi
    '';
  };
}
