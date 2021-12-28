class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/v0.5.11.tar.gz"
  sha256 "ca22a600b5b1c0ca1acff6fd1ce05680a581795567f759ff99a917401bfd835e"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mcfly"
    sha256 cellar: :any_skip_relocation, mojave: "4938436278caedc287b14c3ec3d99fc929c2986d0e10245df002b7f932cc433b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end
