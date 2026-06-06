class InksteadWriter < Formula
  desc "Launcher for Inkstead Writer personal website publishing"
  homepage "https://inkstead.dev/writer"
  url "https://github.com/ivonunes/inkstead-writer/releases/download/v2.0.4/inkstead-writer-v2.0.4",
      using: :nounzip
  sha256 "65ccda4d396be2a6bb616166686b25e1a512122f1cb9d804cd198b082ad27b56"
  version "2.0.4"
  license "MIT"

  def install
    bin.install cached_download => "inkstead-writer"
  end

  test do
    assert_match "Inkstead Writer launcher", shell_output("#{bin}/inkstead-writer --help")
  end
end
