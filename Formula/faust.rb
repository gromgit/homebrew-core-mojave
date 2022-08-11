class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.41.1/faust-2.41.1.tar.gz"
  sha256 "72145e1d4ffcdd8e687ed7960d1d0717fa2c1dd2566e0bbc3a78fa95bb8b683e"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/faust"
    sha256 cellar: :any, mojave: "a825472d524cacd54dec13b790d1014844b5e1bf720c0aae5522695910d7093d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm"

  on_linux do
    depends_on "gcc"
  end

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
