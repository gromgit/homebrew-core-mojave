class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v0.12.0.tar.gz"
  sha256 "fbbbcf5e65b370fde6765a2257c6d2f12cb9568bdce785b0f548c2be28d08cd7"
  license "MIT"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/genact"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f9e280299f88207d777cb9d9082929e55df26c35da3e9a261f66bec09b2b8516"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
