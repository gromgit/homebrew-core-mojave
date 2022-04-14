class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.3.11.tar.gz"
  sha256 "094cfb80e2c099763453fc39cfa9c46cfa423afa858268c6a7bc0d867763b014"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/py-spy"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "180ec76b7920da80ad2f269cf23bc51804c747a23771e7c6e8965c68a7f5e412"
  end

  depends_on "rust" => :build
  depends_on "python@3.10" => :test

  on_linux do
    depends_on "libunwind"
  end

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
    python = Formula["python@3.10"].opt_bin/"python3"
    output = shell_output("#{bin}/py-spy record #{python} 2>&1", 1)
    assert_match "Try running again with elevated permissions by going", output
  end
end
