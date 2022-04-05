class Mmv < Formula
  desc "Move, copy, append, and link multiple files"
  homepage "https://github.com/rrthomas/mmv"
  url "https://github.com/rrthomas/mmv/releases/download/v2.3/mmv-2.3.tar.gz"
  sha256 "bb5bd39e4df944143acefb5bf1290929c0c0268154da3345994059e6f9ac503a"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mmv"
    sha256 cellar: :any, mojave: "2fb03d285294d9a9de881545dc4605043462e782ae983cb69ac4bfb316ec24a9"
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"a").write "1"
    (testpath/"b").write "2"

    assert_match "a -> b : old b would have to be deleted", shell_output("#{bin}/mmv -p a b 2>&1", 1)
    assert_predicate testpath/"a", :exist?
    assert_match "a -> b (*) : done", shell_output("#{bin}/mmv -d -v a b")
    refute_predicate testpath/"a", :exist?
    assert_equal "1", (testpath/"b").read

    assert_match "b -> c : done", shell_output("#{bin}/mmv -s -v b c")
    assert_predicate testpath/"b", :exist?
    assert_predicate testpath/"c", :symlink?
    assert_equal "1", (testpath/"c").read
  end
end
