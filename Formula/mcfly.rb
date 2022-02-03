class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/v0.5.13.tar.gz"
  sha256 "b4dc5fab1ef1fe05fc34b620f1dea6617b48d6d0e3aadcf29a4c9e4cb0894983"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mcfly"
    sha256 cellar: :any_skip_relocation, mojave: "84504564465f49a6eabd0da93b35128775196bf6548a125bbb59cc28f6c7a650"
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
