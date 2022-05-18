class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.io/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1.SVN"
  revision 3
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fuego"
    rebuild 2
    sha256 mojave: "a66157f38cce28dfe91a86d0fb7c30273da2d4380567e7b0889306d4cc55276f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install", "LIBS=-lpthread"
  end

  test do
    input = <<~EOS
      genmove white
      genmove black
    EOS
    output = pipe_output("#{bin}/fuego 2>&1", input, 0)
    assert_match "Forced opening move", output
    assert_match "maxgames", shell_output("#{bin}/fuego --help")
  end
end
