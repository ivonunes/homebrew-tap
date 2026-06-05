class Plume < Formula
  desc "Templating language for building expressive websites"
  homepage "https://inkstead.dev/plume"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plume/releases/download/v1.0.0/plume-v1.0.0-macos-arm64.tar.gz"
      sha256 "55c93f3ef71bc4ba76e94cfdc8c1bd7edf90503cbfd4e42d273553a8d137f7ea"
    else
      url "https://github.com/ivonunes/plume/releases/download/v1.0.0/plume-v1.0.0-macos-x86_64.tar.gz"
      sha256 "246665114c8919a66b7614748401ff880af6f4c2d81c792559d7ad7f35a836f4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plume/releases/download/v1.0.0/plume-v1.0.0-linux-arm64.tar.gz"
      sha256 "b892ed10ec572c53b2c82c4a31326a5d527154a958861a9fc8dcf0c402daa7e7"
    else
      url "https://github.com/ivonunes/plume/releases/download/v1.0.0/plume-v1.0.0-linux-x86_64.tar.gz"
      sha256 "bf90c2e6b902692c965fbc794002b4d0d1b58934b1bad0680086c31843bda28e"
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
