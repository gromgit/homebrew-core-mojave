class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v1.2.2.tar.gz"
  sha256 "72ead4b84e4ca733ae8a25614d44df3f3db5e47e54913ed9fbfecd2f5212a632"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/genact"
    sha256 cellar: :any_skip_relocation, mojave: "ac33184d75ecc822fb90b2a826098048256c70984e448587948f6249083f4b36"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
