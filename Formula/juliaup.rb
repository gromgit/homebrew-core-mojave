class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.5.29.tar.gz"
  sha256 "4dc02d9e7ecddf7364b1862d8b478c2a6f01e0eea9dd755e40e171c42d0b3511"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/juliaup"
    sha256 cellar: :any_skip_relocation, mojave: "4fffdf7db4fbb95648208be937d7acc7de0d72f70fe22a749278be49e0553526"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
