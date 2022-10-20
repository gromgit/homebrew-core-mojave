class Jimtcl < Formula
  desc "Small footprint implementation of Tcl"
  homepage "http://jim.tcl.tk/index.html"
  url "https://github.com/msteveb/jimtcl/archive/0.81.tar.gz"
  sha256 "ab7eb3680ba0d16f4a9eb1e05b7fcbb7d23438e25185462c55cd032a1954a985"
  license "BSD-2-Clause"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jimtcl"
    sha256 mojave: "66639cbf080a3a24af7ffd1e3bf13befe9b704c83b7a9978c7e41280e3f60f2a"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  # Fix EOF detection with openssl@3. Remove in the next release.
  patch do
    url "https://github.com/msteveb/jimtcl/commit/b0271cca8e335a1ebe4e3d6a8889bd4d7d5e30e6.patch?full_index=1"
    sha256 "dbeeb8bb9a1174c4c0d44d8dafc1958994417014176c12d959daa8b31aa4b5b0"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--full",
                          "--with-ext=readline,rlprompt,sqlite3",
                          "--shared",
                          "--docdir=#{doc}",
                          "--maintainer",
                          "--math",
                          "--ssl",
                          "--utf8"
    system "make"
    system "make", "install"
    pkgshare.install Dir["examples*"]
  end

  test do
    (testpath/"test.tcl").write "puts {Hello world}"
    assert_match "Hello world", shell_output("#{bin}/jimsh test.tcl")
  end
end
