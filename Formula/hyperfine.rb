class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.15.0.tar.gz"
  sha256 "b1a7a11a1352cdb549cc098dd9caa6c231947cc4dd9cd91ec25072d6d2978172"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hyperfine.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hyperfine"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "7a61f7b8d752b6f31ea45d0757c2696ed9da22fee30c586f63cce2e0263a51a4"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    man1.install "doc/hyperfine.1"
    bash_completion.install "hyperfine.bash"
    fish_completion.install "hyperfine.fish"
    zsh_completion.install "_hyperfine"
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark 1: sleep", output
  end
end
