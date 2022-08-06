class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/v0.6.1.tar.gz"
  sha256 "e2eebca8f66ec99ff8582886a10e8dfa1a250329ac02c27855698c8d4a33a3f2"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mcfly"
    sha256 cellar: :any_skip_relocation, mojave: "c7acd66599ceec51f3c017fa978dab9fa5e1d3bbcb80443a4a89070fd13c0297"
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
