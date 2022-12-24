class BoreCli < Formula
  desc "Modern, simple TCP tunnel in Rust that exposes local ports to a remote server"
  homepage "http://bore.pub"
  url "https://github.com/ekzhang/bore/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "707459f6fde45139741d039910a1ec5095739ac31ed9b447c46624d71b1274b3"
  license "MIT"
  head "https://github.com/ekzhang/bore.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bore-cli"
    sha256 cellar: :any_skip_relocation, mojave: "5f89ac0e49f2607dac4d038b8f87ac0408fc107a4f0c612af37f1f3b73889a6f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}/bore server")
    assert_match "server listening", stdout.gets("\n")

    assert_match version.to_s, shell_output("#{bin}/bore --version")
  ensure
    Process.kill("TERM", wait_thr.pid)
    Process.wait(wait_thr.pid)
  end
end
