class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.3.11.tar.gz"
  sha256 "094cfb80e2c099763453fc39cfa9c46cfa423afa858268c6a7bc0d867763b014"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/py-spy"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a25b865824445bb4047eead715b8ca54b2bc0cc1c1221597a62ae91631d0e9d2"
  end

  depends_on "rust" => :build
  depends_on "python@3.9" => :test

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"py-spy", "completions", "bash")
    (bash_completion/"py-spy").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"py-spy", "completions", "zsh")
    (zsh_completion/"_py-spy").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"py-spy", "completions", "fish")
    (fish_completion/"py-spy.fish").write fish_output
  end

  test do
    output = shell_output("#{bin}/py-spy record python3.9 2>&1", 1)
    assert_match "This program requires root", output
  end
end
