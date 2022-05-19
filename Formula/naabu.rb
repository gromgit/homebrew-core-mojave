class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.0.7.tar.gz"
  sha256 "dabd5f7b883f806483b2a5a879c583840cdda74dc6f3d3781b1b375744e9feac"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/naabu"
    sha256 cellar: :any_skip_relocation, mojave: "25699589abcde361855c70d747fa67a5b372c33ed6b5de2914a0372bfe7f5f8e"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
