class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/2.2.0.tar.gz"
  sha256 "6a0a19ca5e73b2bef9481c29a508d2413ca1a0a9a5a6b1bd9bbd695a7626cbf9"
  license "Apache-2.0"
  head "https://github.com/ggreer/the_silver_searcher.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/the_silver_searcher"
    rebuild 1
    sha256 cellar: :any, mojave: "3f4d16431e7baa905fb64480a63b3e55bca4dc4ec616aa41450553048e8b589a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "xz"

  def install
    # Stable tarball does not include pre-generated configure script
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    bash_completion.install "ag.bashcomp.sh"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/ag", "Hello World!", testpath
  end
end
