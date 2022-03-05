class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/7.0.1.tar.gz"
  sha256 "74615f186690e43ec2f9b352d11b0905d003c617aef8f4bdacc2146b18611079"
  license "GPL-3.0-or-later"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/findomain"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "25dc99bdf9708ea6dc23aaa753f32ae46885fdb704e08fa5ff0ab2c56afbe4d3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
