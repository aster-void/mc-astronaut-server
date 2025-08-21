{
  description = "A Minecraft Server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };

      name = "mc-astronaut-server";
      serverBin = pkgs.writeShellApplication {
        inherit name;
        runtimeInputs = [
          pkgs.bash
          pkgs.openjdk24_headless
          pkgs.rsync
        ];
        text = ''
          # Create and use a dedicated server directory
          SERVER_DIR=~/srv/github.com/aster-void/mc-astronaut-server
          SOURCE_DIR=${./.}

          # Create server directory if it doesn't exist
          mkdir -p "$SERVER_DIR"
          cd "$SERVER_DIR"

          # Always sync server files from source, preserving world data
          echo "Syncing server files (preserving world data)..."

          # Copy new files and update existing ones, excluding world data
          rsync -av --delete \
            --exclude='world/' \
            --exclude='logs/' \
            --exclude='crash-reports/' \
            --exclude='playerdata/' \
            --exclude='stats/' \
            --exclude='advancements/' \
            --exclude='usercache.json' \
            --exclude='whitelist.json' \
            --exclude='ops.json' \
            --exclude='banned-*.json' \
            "$SOURCE_DIR"/ ./

          chmod -R u+w . 2>/dev/null || true
          echo "Server files updated. Starting server..."
          ./run.sh
        '';
      };
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          # runtime dep
          openjdk
          # build dep
          git

          # general utilities
          ncdu
          btop
        ];
      };

      packages.default = serverBin;

      apps.default = {
        type = "app";
        program = "${serverBin}/bin/${name}";
      };
    });
}
