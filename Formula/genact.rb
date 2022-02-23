class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v0.12.0.tar.gz"
  sha256 "fbbbcf5e65b370fde6765a2257c6d2f12cb9568bdce785b0f548c2be28d08cd7"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/genact"
    sha256 cellar: :any_skip_relocation, mojave: "fb34bc3269f6d459f23d20801d46c4c7468fb38e82b6b738e25212b8dcac9fc8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
