class Sniffer < Formula
  desc "Modern alternative network traffic sniffer"
  homepage "https://github.com/chenjiandongx/sniffer"
  url "https://github.com/chenjiandongx/sniffer/archive/v0.6.0.tar.gz"
  sha256 "5f6479baf3fa003aa25247d280f4a8bf2130a346a20e6feb497633650900056f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sniffer"
    sha256 cellar: :any_skip_relocation, mojave: "5f1108f6891135e303df77e60d61aa5af6bdc58a1218a3774999f6b2348acb40"
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
