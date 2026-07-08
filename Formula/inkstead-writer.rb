class InksteadWriter < Formula
  desc "Launcher for Inkstead Writer personal website publishing"
  homepage "https://inkstead.dev/writer"
  url "https://github.com/ivonunes/inkstead-writer/releases/download/v2.2.0/inkstead-writer-v2.2.0",
      using: :nounzip
  sha256 "fb8e09a3c483e6dade2e8f3dcc03fd6a305d9c23330ee87ad1abd2884a49dcf6"
  version "2.2.0"
  license "MIT"

  def install
    bin.install cached_download => "inkstead-writer"
  end

  test do
    assert_match "Inkstead Writer launcher", shell_output("#{bin}/inkstead-writer --help")
  end
end
