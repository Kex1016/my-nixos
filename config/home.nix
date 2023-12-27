{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  home-manager.users.michiru = { pgks, ... }: {
    programs = {
      nushell = {
        enable = true;
        # The config.nu can be anywhere you want if you like to edit your Nushell with Nu
        configFile.source = ./shell.nu;
        shellAliases = {
          vi = "v";
          vim = "v";
          nano = "v";
          v = "nvim";
          sv = "sudo nvim";
          cd = "z";
        };
      };

      carapace.enable = true;
      carapace.enableNushellIntegration = true;

      starship = {
        enable = true;
        settings = {
          add_newline = true;
          character = {
            success_symbol = "[➜](bold green)";
            error_symbol = "[➜](bold red)";
          };
        };
      };

      zoxide = {
        enable = true;
        enableNushellIntegration = true;
      };
    };

    home.stateVersion = "23.11";
  };
}
