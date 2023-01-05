class Flac123 < Formula
  desc "Command-line program for playing FLAC audio files"
  homepage "https://flac-tools.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/flac-tools/flac123/flac123-0.0.12-release.tar.gz"
  sha256 "1976efd54a918eadd3cb10b34c77cee009e21ae56274148afa01edf32654e47d"
  license "GPL-2.0"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/flac123"
    rebuild 1
    sha256 cellar: :any, mojave: "390dde9183c215233f46c81fd8da3a9ef7e1a7d7ea2588b3d28029ff58d209bf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "popt"

  def install
    ENV["ACLOCAL"] = "aclocal"
    ENV["AUTOMAKE"] = "automake"
    system "aclocal"
    system "automake", "--add-missing"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}"
  end

  test do
    driver = OS.mac? ? "macosx" : "oss"
    system "#{bin}/flac123", "-d=#{driver}"
  end
end
