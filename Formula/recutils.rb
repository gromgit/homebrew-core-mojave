class Recutils < Formula
  desc "Tools to work with human-editable, plain text data files"
  homepage "https://www.gnu.org/software/recutils/"
  url "https://ftp.gnu.org/gnu/recutils/recutils-1.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/recutils/recutils-1.9.tar.gz"
  sha256 "6301592b0020c14b456757ef5d434d49f6027b8e5f3a499d13362f205c486e0e"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/recutils"
    sha256 mojave: "ada1f13781b8907524ceb508c9c1e210ed5153c9ed9af83442b7b8c3944ac829"
  end

  on_linux do
    depends_on "libgcrypt"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--datarootdir=#{elisp}"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    system "#{bin}/csv2rec", "test.csv"

    (testpath/"test.rec").write <<~EOS
      %rec: Book
      %mandatory: Title

      Title: GNU Emacs Manual
    EOS
    system "#{bin}/recsel", "test.rec"
  end
end
