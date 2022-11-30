class Xml2 < Formula
  desc "Makes XML and HTML more amenable to classic UNIX text tools"
  homepage "https://web.archive.org/web/20160730094113/www.ofb.net/~egnor/xml2/"
  url "https://web.archive.org/web/20160427221603/download.ofb.net/gale/xml2-0.5.tar.gz"
  sha256 "e3203a5d3e5d4c634374e229acdbbe03fea41e8ccdef6a594a3ea50a50d29705"
  license "GPL-2.0"

  livecheck do
    skip "Upstream is gone and the formula uses archive.org URLs"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xml2"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "c1560ddacb36984c168ea9869b2b3f9f96069916573a0e42eb7aee78707787f2"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libxml2"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "/test", pipe_output("#{bin}/xml2", "<test/>", 0).chomp
  end
end
