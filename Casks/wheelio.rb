cask "wheelio" do
  version "2.0.0"
  sha256 "e6d23fa13a68d97bec7bc8fd728b5856f0d45d25f33ab46bfdb22d4af5181431"

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
