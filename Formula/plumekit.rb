class Plumekit < Formula
  desc "Delightful Swift web framework that runs anywhere"
  homepage "https://plumekit.dev"
  version "3.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.0/plumekit-v3.1.0-macos-arm64.tar.gz"
      sha256 "de8c2e6f2dd76b19bd8f1c46e7ea20b5336a1688ab36a75220de11a528112b11"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.0/plumekit-v3.1.0-macos-x86_64.tar.gz"
      sha256 "59377a9b0884f18fb43e9a81280ac309bc56c597a74a3da513d5fad2199c6fcf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.0/plumekit-v3.1.0-linux-arm64.tar.gz"
      sha256 "4d791e2d6db9a8862efc0e8086edf9abe5ada5b2c5f2cf9fe70af765662c364b"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.0/plumekit-v3.1.0-linux-x86_64.tar.gz"
      sha256 "e985eb2680101336669989b19862ae8e7905887761f086fe905a3aa508884ad5"
    end
  end

  def install
    bin.install "plumekit"
    prefix.install "LICENSE.txt" if File.exist?("LICENSE.txt")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plumekit version")
    (testpath/"sample.plume").write("@let title = \"Hello\"\n<h1>{ title }</h1>\n")
    assert_match "Plume check passed", shell_output("#{bin}/plumekit check #{testpath}")
  end
end
