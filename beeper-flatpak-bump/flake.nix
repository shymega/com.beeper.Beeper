{
  description = "[UNOFFICIAL] A small utility for bumping the version of Beeper Desktop for Linux (x86_64 currently) in the Flatpak";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    goVersion = 23;

    supportedSystems = ["x86_64-linux" "aarch64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
          };
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}:
      with pkgs; with lib; {
        default = mkShell {
          inputsFrom = singleton self.packages.${system}.beeper-flatpak-bump;
          packages = [
            pdm
            self.packages.${system}.beeper-flatpak-bump
          ];
        };
      });

    packages = forEachSupportedSystem ({pkgs}:
      with pkgs; {
        default = self.packages.${system}.beeper-flatpak-bump;
        beeper-flatpak-bump = with python3Packages;
          buildPythonApplication {
            pname = "beeper-flatpak-bump";
            version = "0.1.0";
            pyproject = true;

            src = ./.;
            build-system = [ pdm-backend ];

            nativeBuildInputs = [ pdm ];
            propagatedBuildInputs = [
              pyyaml
              requests
            ];
          };
      });
  };
}
