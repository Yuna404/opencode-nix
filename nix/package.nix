{ lib
, appimageTools
, fetchurl
, makeDesktopItem
}:

let
  pname = "opencode-desktop";
  version = "2.4.2";

  src = fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-desktop-linux-x86_64.AppImage";
    hash = "sha256-tCwjhIe90I7lUdCAU+alp2W9e+xl98qJn+xmRkvQ+ys=";
  };

  extracted = appimageTools.extract { inherit pname version src; };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "OpenCode";
    comment = "OpenCode desktop app";
    exec = "${pname} --no-sandbox %U";
    icon = pname;
    terminal = false;
    categories = [ "Development" ];
    mimeTypes = [ "x-scheme-handler/opencode" ];
    startupWMClass = "ai.opencode.desktop";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [
    libxkbcommon
    libGL
    vulkan-loader
    wayland
  ];

  extraInstallCommands = ''
    install -Dm444 ${desktopItem}/share/applications/*.desktop \
      -t $out/share/applications

    icon=$(find ${extracted}/usr/share/icons -name '*.png' 2>/dev/null | sort -V | tail -n1)
    if [ -z "$icon" ]; then
      icon=$(find ${extracted} -maxdepth 1 -name '*.png' | head -n1)
    fi
    if [ -n "$icon" ]; then
      install -Dm444 "$icon" $out/share/pixmaps/${pname}.png
    fi
  '';

  meta = {
    description = "OpenCode desktop app";
    homepage = "https://github.com/anomalyco/opencode";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
