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
          pkgs.openjdk24_headless
        ];
        text = ''
          # Create and use a dedicated server directory
          SERVER_DIR=~/srv/github.com/aster-void/mc-astronaut-server

          # Create server directory if it doesn't exist
          mkdir -p "$SERVER_DIR"
          cd "$SERVER_DIR"

          # Copy server files from source if they don't exist
          if [ ! -f "user_jvm_args.txt" ]; then
            cp -r ${./.}/* . 2>/dev/null || true
            chmod -R u+w . 2>/dev/null || true
          fi
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
