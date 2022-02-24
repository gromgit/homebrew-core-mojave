class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/rrthomas/recode"
  url "https://github.com/rrthomas/recode/releases/download/v3.7.12/recode-3.7.12.tar.gz"
  sha256 "4db1c9076f04dbaa159726f5000847e5e5a83aec8e5c64f8ca04383f6cda12d5"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/recode"
    sha256 cellar: :any, mojave: "1bcca901d96571e340bcadb79b1370ba2ccb6d9d637e3547fae8c95afa68a1d0"
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
