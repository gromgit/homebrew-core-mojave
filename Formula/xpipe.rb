class Xpipe < Formula
  desc "Split input and feed it into the given utility"
  homepage "https://www.netmeister.org/apps/xpipe.html"
  url "https://www.netmeister.org/apps/xpipe-2.1.tar.gz"
  sha256 "0d0656a738fcec16dc01e5a6a62e9d9e00016ea750bc5f972ee077022dd04715"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.netmeister.org/apps/"
    regex(/href=.*?xpipe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xpipe"
    sha256 cellar: :any_skip_relocation, mojave: "89f8bf2b2db995b0df683c96a16f9069bedc4ac19eb0c67457411e3719025ced"
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
