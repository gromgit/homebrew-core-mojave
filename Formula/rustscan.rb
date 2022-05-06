class Rustscan < Formula
  desc "Modern Day Portscanner"
  homepage "https://github.com/rustscan/rustscan"
  url "https://github.com/RustScan/RustScan/archive/2.1.0.tar.gz"
  sha256 "10958957148544da780c1be4004b906e94bafe02a19f0224f6026828fb77a8cc"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rustscan"
    sha256 cellar: :any_skip_relocation, mojave: "7f54f1f69302fa207261ed783ac87900c88d0c5ab71ef83db2b432389fbb77ce"
  end

  depends_on "rust" => :build
  depends_on "nmap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    refute_match("panic", shell_output("#{bin}/rustscan --greppable -a 127.0.0.1"))
    refute_match("panic", shell_output("#{bin}/rustscan --greppable -a 0.0.0.0"))
  end
end
