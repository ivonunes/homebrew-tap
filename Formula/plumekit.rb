class Plumekit < Formula
  desc "Delightful Swift web framework that runs anywhere"
  homepage "https://plumekit.dev"
  version "2.0.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v2.0.1/plumekit-v2.0.1-macos-arm64.tar.gz"
      sha256 "673c21434bfdbc89c72def7ed0ddb6b801dc9ac8bd16052b3a6220dd8ff65fea"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v2.0.1/plumekit-v2.0.1-macos-x86_64.tar.gz"
      sha256 "20298d0aad36ddf5cab8df9d7b307bbc493ec6dccbff1641bed234856531d56a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v2.0.1/plumekit-v2.0.1-linux-arm64.tar.gz"
      sha256 "509cffdf5ffc1a19605ee26c32f5189499eb7ae6f9df4dbda4ead444ff7f2db6"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v2.0.1/plumekit-v2.0.1-linux-x86_64.tar.gz"
      sha256 "fa92324480c668b4e3b63a3940006a5c55ce22cf23b7ab190ba94164d545597d"
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
