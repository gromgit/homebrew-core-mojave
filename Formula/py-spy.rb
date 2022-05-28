class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "6a4b0537e0bf9cf40fc4557931955222a25db01c110309d0b642dd28211bffeb"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/py-spy"
    sha256 cellar: :any_skip_relocation, mojave: "b548a7ae3b327d1391f1f9ebb6aa691271fa40c41ac86fedc2d14dd725d83a5d"
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
