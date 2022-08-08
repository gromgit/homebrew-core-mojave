class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta/archive/v1.0.8.tar.gz"
  sha256 "b6d1691424b13e28a953a2661e1f3261ecbeb607574ad217e18c4cf62ab48df4"
  license "BSD-2-Clause"
  head "https://github.com/volta-cli/volta.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/volta"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "50b58bb2b059f2197a1a01dfaa74620eec4afb44917e1d6050de210c356048da"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"volta", "completions", "bash")
    (bash_completion/"volta").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"volta", "completions", "zsh")
    (zsh_completion/"_volta").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"volta", "completions", "fish")
    (fish_completion/"volta.fish").write fish_output
  end

  test do
    system bin/"volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
