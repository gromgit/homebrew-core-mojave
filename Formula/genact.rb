class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v1.1.1.tar.gz"
  sha256 "231ea3735c59a659264d11b7ef1a6a2572c73f7bd7c9cb3efb940709673b58bf"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/genact"
    sha256 cellar: :any_skip_relocation, mojave: "497818c75d9504e1f169d5b43163a810a55b0a83c5a107971d39164770504e91"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
