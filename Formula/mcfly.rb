class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/v0.6.0.tar.gz"
  sha256 "dd846f7ff7109921febc8aecdfd769a1258488a0d72b4a0cfcfa3eaac118b1bc"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mcfly"
    sha256 cellar: :any_skip_relocation, mojave: "817286da087aaf0630af96c5db95727a44f8d948d1fb5056b7ac0127aa7340c5"
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
