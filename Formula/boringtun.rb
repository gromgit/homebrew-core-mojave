class Boringtun < Formula
  desc "Userspace WireGuard implementation in Rust"
  homepage "https://github.com/cloudflare/boringtun"
  url "https://github.com/cloudflare/boringtun/archive/v0.4.0.tar.gz"
  sha256 "23a02ae0c01d194ce428c465de46538f683c696fa23a82cfc42d07d40e668e74"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/boringtun.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/boringtun"
    sha256 cellar: :any_skip_relocation, mojave: "43945009603f50dec34286899132f22de093d01c2a1e012be4f515c0f2a36646"
  end

  depends_on "rust" => :build

  def install
    args = build.head? ? std_cargo_args(path: "boringtun-cli") : std_cargo_args
    system "cargo", "install", *args
  end

  def caveats
    <<~EOS
      boringtun requires root privileges so you will need to run `sudo boringtun utun`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    system "#{bin}/boringtun", "--help"
    assert_match "boringtun #{version}", shell_output("#{bin}/boringtun -V").chomp

    output = shell_output("#{bin}/boringtun utun -v --log #{testpath}/boringtun.log 2>&1", 1)
    assert_predicate testpath/"boringtun.log", :exist?
    # requires `sudo` to start
    assert_match "BoringTun failed to start", output
  end
end
