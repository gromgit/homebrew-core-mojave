class Jupp < Formula
  desc "Professional screen editor for programmers"
  homepage "https://www.mirbsd.org/jupp.htm"
  url "https://www.mirbsd.org/MirOS/dist/jupp/joe-3.1jupp40.tgz"
  version "3.1jupp40"
  sha256 "4bed439cde7f2be294e96e49ef3e913ea90fbe5e914db888403e3a27e8035b1a"
  license "GPL-1.0-or-later"
  # Upstream HEAD in CVS: http://www.mirbsd.org/cvs.cgi/contrib/code/jupp/

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jupp"
    sha256 mojave: "6e05e725543113faf3f2aca8fc543714171ca70a2f62211a7cfdcc04b59d8d40"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "expect" => :test

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  conflicts_with "joe", because: "both install the same binaries"

  def install
    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin" if OS.mac?
    system "autoreconf", "-vfi"
    system "./configure", *std_configure_args,
                          "--enable-sysconfjoesubdir=/jupp"
    system "make", "install"
  end

  test do
    assert_match "File (Unnamed) not changed so no update needed.",
      pipe_output("env TERM=tty expect -",
                  "spawn #{bin}/jupp;send \"q\";expect eof")
  end
end
