{ lib
, appimageTools
, fetchurl
, makeDesktopItem
}:

let
  pname = "opencode-desktop";
  version = "1.19.6";

  src = fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-desktop-linux-x86_64.AppImage";
    hash = "sha256-nuGVO1BGN2NDVqcnTmI0bevgrBLU9tk/kPG+LLSyZqk=";
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

    install -Dm444 ${extracted}/ai.opencode.desktop.png \
      $out/share/pixmaps/${pname}.png
  '';

  meta = {
    description = "OpenCode desktop app";
    homepage = "https://github.com/anomalyco/opencode";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
