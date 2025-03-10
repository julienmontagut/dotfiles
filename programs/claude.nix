{ pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    nodejs # Explicitly include nodejs in packages
    (pkgs.writeShellScriptBin "claude" ''
      ${pkgs.nodejs}/bin/node ${config.home.homeDirectory}/.npm-global/bin/claude "$@"
    '')
  ];

  home.sessionPath = [ "$HOME/.npm-global/bin" ];
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    # Ensure npm scripts can find node
    NODE = "${pkgs.nodejs}/bin/node";
  };

  home.activation = {
    installClaudeCode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if ! [ -d "$HOME/.npm-global" ]; then
        $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "$HOME/.npm-global"
      fi

      # Create a symlink to node in a directory that's in the default PATH
      $DRY_RUN_CMD mkdir -p "$HOME/.npm-global/bin"
      $DRY_RUN_CMD ln -sf "${pkgs.nodejs}/bin/node" "$HOME/.npm-global/bin/node"

      # Ensure node is in PATH for npm scripts
      export PATH="${pkgs.nodejs}/bin:$HOME/.npm-global/bin:$PATH"

      # Set NODE explicitly for npm scripts
      export NODE="${pkgs.nodejs}/bin/node"

      echo "Setting npm config..."
      $DRY_RUN_CMD ${pkgs.nodejs}/bin/npm config set prefix "$HOME/.npm-global"
      $DRY_RUN_CMD ${pkgs.nodejs}/bin/npm config set scripts-prepend-node-path true

      # Check if claude-code is installed, if not install it
      if ! [ -e "$HOME/.npm-global/bin/claude" ]; then
        echo "Installing @anthropic-ai/claude-code..."
        $DRY_RUN_CMD PATH="${pkgs.nodejs}/bin:$HOME/.npm-global/bin:$PATH" ${pkgs.nodejs}/bin/npm install -g @anthropic-ai/claude-code || {
          echo "Failed to install claude-code. Check if Node.js is available with: which node"
          echo "Current NODE env: $NODE"
          echo "Current PATH: $PATH"
          return 1
        }
      else
        # Check for updates if already installed
        echo "Updating @anthropic-ai/claude-code..."
        $DRY_RUN_CMD PATH="${pkgs.nodejs}/bin:$HOME/.npm-global/bin:$PATH" ${pkgs.nodejs}/bin/npm update -g @anthropic-ai/claude-code || {
          echo "Failed to update claude-code."
          return 1
        }
      fi

      echo "Claude CLI setup complete."
    '';
  };
}
