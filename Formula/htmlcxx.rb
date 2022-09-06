class Htmlcxx < Formula
  desc "Non-validating CSS1 and HTML parser for C++"
  homepage "https://htmlcxx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/htmlcxx/v0.87/htmlcxx-0.87.tar.gz"
  sha256 "5d38f938cf4df9a298a5346af27195fffabfef9f460fc2a02233cbcfa8fc75c8"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/htmlcxx"
    rebuild 1
    sha256 mojave: "552a5ce4a36d7f0aff8e6912fe485b7b4065c1c24e5e0268b56acb9d92f88b72"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/htmlcxx -V 2>&1").chomp
  end
end
