cask "wheelio" do
  version "3.0.0"
  sha256 "931998bcaf588ee64a1c2e9844dbd2456b887de32081a066f48f098042230137"

  url "https://github.com/ivonunes/wheelio/releases/download/v#{version}/wheelio-#{version}.zip"
  name "Wheelio"
  desc "Play Windows driving games from Steam with force feedback wheels and VR"
  homepage "https://github.com/ivonunes/wheelio"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "wheelio-#{version}/Wheelio.app"

  uninstall quit: "uk.ivonunes.wheelio"

  # Not Application Support/Wheelio/Steam: it holds the library Steam loads
  # while Steam Play is on, and Valve's copy of Steam.app to put back.
  zap trash: [
    "~/Library/Application Support/Wheelio/Engine",
    "~/Library/Application Support/Wheelio/GamePortingToolkit",
    "~/Library/Caches/uk.ivonunes.wheelio",
    "~/Library/HTTPStorages/uk.ivonunes.wheelio",
    "~/Library/Preferences/uk.ivonunes.wheelio.plist",
  ]

  caveats <<~EOS
    Before uninstalling, turn off Play Windows games in Steam in Wheelio's
    Settings, so it puts Valve's own Steam back.
  EOS
end
