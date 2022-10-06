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
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "813453ec9c97926b3eb263f4793bb7376f2527b1d54a15e3e7f5f77568885fd5"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"volta", "completions")
  end

  test do
    system bin/"volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
