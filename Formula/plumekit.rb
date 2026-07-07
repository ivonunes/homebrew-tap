class Plumekit < Formula
  desc "Delightful Swift web framework that runs anywhere"
  homepage "https://plumekit.dev"
  version "2.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v2.0.0/plumekit-v2.0.0-macos-arm64.tar.gz"
      sha256 "5dc4d7e03c381450745d2a75e8c86b8f9c5369ca7846db8f52e59934e1696183"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v2.0.0/plumekit-v2.0.0-macos-x86_64.tar.gz"
      sha256 "9c2d1ec34f9be6af5fa3a61b80c7689e51f37ecffbe37e4deac61492a1c3701b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v2.0.0/plumekit-v2.0.0-linux-arm64.tar.gz"
      sha256 "13d426dd16c0dfacb931882c9282fe14daa763d37b4b964f512ce645ca47c4cf"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v2.0.0/plumekit-v2.0.0-linux-x86_64.tar.gz"
      sha256 "1b50dab708b845ea9d468a59b390df3f33a80f872cd397d60c6147284626ee42"
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
