class Flactag < Formula
  desc "Tag single album FLAC files with MusicBrainz CUE sheets"
  homepage "https://flactag.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/flactag/v2.0.4/flactag-2.0.4.tar.gz"
  sha256 "c96718ac3ed3a0af494a1970ff64a606bfa54ac78854c5d1c7c19586177335b2"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/flactag"
    sha256 cellar: :any, mojave: "ba1430c6e515e1a250e1c70dc5036674a7c0943f9b5778bd417d491a08d75c58"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "jpeg-turbo"
  depends_on "libdiscid"
  depends_on "libmusicbrainz"
  depends_on "neon"
  depends_on "s-lang"
  depends_on "unac"

  uses_from_macos "libxslt"

  # jpeg 9 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ed0e680/flactag/jpeg9.patch"
    sha256 "a8f3dda9e238da70987b042949541f89876009f1adbedac1d6de54435cc1e8d7"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    ENV.append "LDFLAGS", "-lFLAC"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/flactag"
  end
end
