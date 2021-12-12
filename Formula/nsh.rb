class Nsh < Formula
  desc "Fish-like, POSIX-compatible shell"
  homepage "https://github.com/nuta/nsh"
  url "https://github.com/nuta/nsh/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "b0c656e194e2d3fe31dc1c6ee15fd5808db3b2428d79adf786c6900ebbba0849"
  license any_of: ["CC0-1.0", "MIT"]
  head "https://github.com/nuta/nsh.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nsh"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "65df86c4fb2311782b94da16f9e517b599632983d8a45c73480aa4f3485da033"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "hello", shell_output("#{bin}/nsh -c \"echo -n hello\"")
  end
end
