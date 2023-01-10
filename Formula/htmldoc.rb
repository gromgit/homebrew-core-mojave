class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.16.tar.gz"
  sha256 "f0d19d8be0fd961d07556f85dbea1d95f0d38728a45dc0f2cf92c715e4140542"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/michaelrsweet/htmldoc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/htmldoc"
    rebuild 1
    sha256 mojave: "ef879f8591c5b03bd4ec9f14c3d7772a12fa2dee354250e3c2f16425afde6602"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gnutls"
  end

  def install
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--without-gui"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/htmldoc", "--version"
  end
end
