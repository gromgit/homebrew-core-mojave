class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.50.6/faust-2.50.6.tar.gz"
  sha256 "d8b7a89d82ee5d3259c8194c363296bc13353160f847661ab84b2dbefdee7173"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/faust"
    sha256 cellar: :any, mojave: "dbcc3c3f0822f80be8690bf3012fac347e060767a9ac825675ffd08d45a8affd"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm@14" # Needs LLVM 14 for `csound`.

  fails_with gcc: "5"

  def install
    ENV.delete "TMP" # don't override Makefile variable
    system "make", "world"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"noise.dsp").write <<~EOS
      import("stdfaust.lib");
      process = no.noise;
    EOS

    system "#{bin}/faust", "noise.dsp"
  end
end
