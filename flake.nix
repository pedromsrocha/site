{
  description = "pedromsr.com — personal website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # Support both Apple Silicon and Intel Macs
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux" ];
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          haskellPackages = pkgs.haskellPackages;
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              haskellPackages.ghc
              haskellPackages.cabal-install

              haskellPackages.hakyll

              pkgs.zlib
            ];

            shellHook = ''
              echo "pedromsr.com dev shell"
              echo "GHC $(ghc --numeric-version) | Cabal $(cabal --numeric-version)"
            '';
          };
        }
      );
    };
}
