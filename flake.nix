{
  description = "OpenCode Desktop pour NixOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      opencode-desktop = pkgs.callPackage ./nix/package.nix { };
    in
    {
      packages.${system} = {
        inherit opencode-desktop;
        default = opencode-desktop;
      };

      apps.${system}.default = {
        type = "app";
        program = "${opencode-desktop}/bin/opencode-desktop";
      };

      overlays.default = final: prev: {
        opencode-desktop = final.callPackage ./nix/package.nix { };
      };
    };
}
