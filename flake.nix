{
  description = "Parker's DNS, managed with octoDNS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (
        pkgs:
        let
          # nixpkgs' octodns.withProviders only exposes the octodns-* commands;
          # script/list-domains.py also needs a python that can import octodns.
          python = pkgs.python3.override {
            self = python;
            packageOverrides = final: prev: {
              octodns = final.toPythonModule pkgs.octodns;
            };
          };
        in
        {
          default = python.withPackages (_: [ pkgs.octodns.providers.cloudflare ]);
        }
      );

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = [
            self.packages.${pkgs.stdenv.hostPlatform.system}.default
            pkgs.curl
          ];
        };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt);
    };
}
