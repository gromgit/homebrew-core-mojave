class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "https://www.wavpack.com/"
  url "https://www.wavpack.com/wavpack-5.5.0.tar.bz2"
  sha256 "7a222f96c391138d340793a1b06d517d7a514de85b5915216051b7386f222977"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wavpack"
    sha256 cellar: :any, mojave: "60f2eebdb9c92023f6af5ce05e7f906ff2723da800034ca193115223928020fc"
  end

  head do
    url "https://github.com/dbry/WavPack.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[--prefix=#{prefix} --disable-dependency-tracking]

    # ARM assembly not currently supported
    # https://github.com/dbry/WavPack/issues/93
    args << "--disable-asm" if Hardware::CPU.arm?

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system bin/"wavpack", test_fixtures("test.wav"), "-o", testpath/"test.wv"
    assert_predicate testpath/"test.wv", :exist?
  end
end
