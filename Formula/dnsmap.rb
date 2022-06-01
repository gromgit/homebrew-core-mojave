class Dnsmap < Formula
  desc "Passive DNS network mapper (a.k.a. subdomains bruteforcer)"
  homepage "https://github.com/resurrecting-open-source-projects/dnsmap"
  url "https://github.com/resurrecting-open-source-projects/dnsmap/archive/refs/tags/0.36.tar.gz"
  sha256 "f52d6d49cbf9a60f601c919f99457f108d51ecd011c63e669d58f38d50ad853c"
  head "https://github.com/resurrecting-open-source-projects/dnsmap.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dnsmap"
    sha256 cellar: :any_skip_relocation, mojave: "ee4c74471e1f23dc93bc79987387e4c014f73d7f7cbae2746731b9ae0b4aa299"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnsmap", 1)
  end
end
