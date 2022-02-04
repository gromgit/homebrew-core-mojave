class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/rrthomas/recode"
  url "https://github.com/rrthomas/recode/releases/download/v3.7.11/recode-3.7.11.tar.gz"
  sha256 "97267a0e6ee3d859b7f4d1593282900dbc798151b70a6d1f73718880563b485e"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/recode"
    sha256 cellar: :any, mojave: "f41def65309616a8ee4a039ec08614f0197a0d01199c924c161d2a5bfbcdf9f5"
  end

  depends_on "libtool" => :build
  depends_on "python@3.10" => :build
  depends_on "gettext"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recode --version")
  end
end
