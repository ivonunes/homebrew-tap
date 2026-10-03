cask "wheelio" do
  version "2.0.0"
  sha256 "e6d23fa13a68d97bec7bc8fd728b5856f0d45d25f33ab46bfdb22d4af5181431"

  url "https://github.com/ivonunes/wheelio/releases/download/v#{version}/wheelio-#{version}.zip"
  name "Wheelio"
  desc "Force feedback for Logitech racing wheels in CrossOver and Wine games"
  homepage "https://github.com/ivonunes/wheelio"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "wheelio-#{version}/Wheelio.app"

  uninstall quit: "uk.ivonunes.wheelio"

  zap trash: [
    "~/Library/Application Support/Wheelio",
    "~/Library/Caches/uk.ivonunes.wheelio",
    "~/Library/HTTPStorages/uk.ivonunes.wheelio",
    "~/Library/Preferences/uk.ivonunes.wheelio.plist",
  ]
end
