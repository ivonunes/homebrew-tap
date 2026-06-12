class Plume < Formula
  desc "Templating language for building expressive websites"
  homepage "https://inkstead.dev/plume"
  version "1.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plume/releases/download/v1.1.0/plume-v1.1.0-macos-arm64.tar.gz"
      sha256 "cd1946af066e0907cd3244eac62f9abbf812ea7cbbd86b46373be1fd1edc9d98"
    else
      url "https://github.com/ivonunes/plume/releases/download/v1.1.0/plume-v1.1.0-macos-x86_64.tar.gz"
      sha256 "95fcfd98050ddc43223b46f0e555f2186ec018972771cfd3e6cfb444049d66f1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plume/releases/download/v1.1.0/plume-v1.1.0-linux-arm64.tar.gz"
      sha256 "cda4bd59a2c3850db902f537faecfa56c6b2e9100cfcca7a94a8128934eedffc"
    else
      url "https://github.com/ivonunes/plume/releases/download/v1.1.0/plume-v1.1.0-linux-x86_64.tar.gz"
      sha256 "5c53a7d91d87f5c97566a29346874574a19e38e207335d0c60b2631d354ff106"
    end
  end

  def install
    bin.install "plume"
    prefix.install "LICENSE.txt" if File.exist?("LICENSE.txt")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plume version")
    (testpath/"sample.plume").write("@let title = \"Hello\"\n<h1>{ title }</h1>\n")
    assert_match "Plume check passed", shell_output("#{bin}/plume check #{testpath}")
  end
end
