class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.10.3/miller-5.10.3.tar.gz"
  sha256 "bbab4555c2bc207297554b0593599ea2cd030a48ad1350d00e003620e8d3c0ea"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/miller"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "77acac9c84e2791facaa5e854219303279402e3e8724d84d41ca5823fb0fc16f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "flex" => :build

  def install
    # Profiling build fails with Xcode 11, remove it
    inreplace "c/Makefile.am", /noinst_PROGRAMS=\s*mlrg/, ""
    system "autoreconf", "-fvi"

    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match "a\n1\n4\n", output
  end
end
