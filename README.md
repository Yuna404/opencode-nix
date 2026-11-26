# opencode-nix

Nix package for [OpenCode Desktop](https://github.com/anomalyco/opencode), based on the official AppImage (not built from source).

A GitHub Action checks for a new release every 6 hours, bumps the version and hash, test-builds the package, then commits automatically. The package stays up to date without any manual work.

## Try it without installing

```sh
nix run github:Yuna404/opencode-nix
```

## Install into your profile

```sh
nix profile install github:Yuna404/opencode-nix
```

## Install on NixOS (flake)

In your `flake.nix`:

```nix
{
  inputs.opencode-nix.url = "github:Yuna404/opencode-nix";
  inputs.opencode-nix.inputs.nixpkgs.follows = "nixpkgs";
}
```

Then in your configuration:

```nix
{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.opencode-nix.packages.${pkgs.system}.default
  ];
}
```

Or with the overlay:

```nix
{ inputs, pkgs, ... }:
{
  nixpkgs.overlays = [ inputs.opencode-nix.overlays.default ];
  environment.systemPackages = [ pkgs.opencode-desktop ];
}
```

## Update

```sh
nix flake update opencode-nix
```

## Notes

- Linux `x86_64` only
- The binary is prebuilt (`binaryNativeCode`); this repo is just a wrapper around the AppImage
