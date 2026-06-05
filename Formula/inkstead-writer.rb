class InksteadWriter < Formula
  desc "Launcher for Inkstead Writer personal website publishing"
  homepage "https://inkstead.dev/writer"
  url "https://github.com/ivonunes/inkstead-writer/releases/download/v2.0.0/inkstead-writer-v2.0.0",
      using: :nounzip
  sha256 "8489918d0df4539ed6fd08d31dc9658ea73c8499207da6fdd9b4eb34a5a4d462"
  version "2.0.0"
  license "MIT"

  def install
    bin.install cached_download => "inkstead-writer"
  end

  test do
    assert_match "Inkstead Writer launcher", shell_output("#{bin}/inkstead-writer --help")
  end
end
