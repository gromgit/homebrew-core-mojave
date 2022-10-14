class Xpipe < Formula
  desc "Split input and feed it into the given utility"
  homepage "https://www.netmeister.org/apps/xpipe.html"
  url "https://www.netmeister.org/apps/xpipe-2.2.tar.gz"
  sha256 "a381be1047adcfa937072dffa6b463455d1f0777db6bc5ea2682cd6321dc5add"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.netmeister.org/apps/"
    regex(/href=.*?xpipe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xpipe"
    sha256 cellar: :any_skip_relocation, mojave: "78781679c3d7bea6ac9be9d10da89942ef500ad6f1a5644c9717081ee3fcbc08"
  end

  on_linux do
    depends_on "libbsd"
  end

  def install
    inreplace "Makefile", "${PREFIX}/include/bsd", "#{Formula["libbsd"].opt_include}/bsd"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "echo foo | xpipe -b 1 -J % /bin/sh -c 'cat >%'"
    assert_predicate testpath/"1", :exist?
    assert_predicate testpath/"2", :exist?
    assert_predicate testpath/"3", :exist?
  end
end
