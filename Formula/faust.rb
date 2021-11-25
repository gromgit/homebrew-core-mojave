class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.37.3/faust-2.37.3.tar.gz"
  sha256 "f14577e9f63041ec341f40a64dae5e9362be8ed77571aa389ed7d389484a31d7"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/faust"
    rebuild 1
    sha256 cellar: :any, mojave: "0a3686d7f3092a871aa31d5a0734cf62cc8cccb5501b519aeb4d39888b8da171"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm@12"

  def install
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
