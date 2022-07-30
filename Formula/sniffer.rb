class Sniffer < Formula
  desc "Modern alternative network traffic sniffer"
  homepage "https://github.com/chenjiandongx/sniffer"
  url "https://github.com/chenjiandongx/sniffer/archive/v0.6.1.tar.gz"
  sha256 "130d588c2472939fc80e3c017a1cae4d515770f1bcab263d985e3be1498d2dbc"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sniffer"
    sha256 cellar: :any_skip_relocation, mojave: "7df4161f6d9a3cb2a1ca82ddda55314511833162426dd17b3874674b816339db"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "lo", shell_output("#{bin}/sniffer -l")
  end
end
