class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://www.gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.28/gphoto2-2.5.28.tar.bz2"
  sha256 "2a648dcdf12da19e208255df4ebed3e7d2a02f905be4165f2443c984cf887375"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/gphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gphoto2"
    sha256 mojave: "629914db98b6062167e4ccd63cfb266ed7c9f25d0f1ad4abdc15277badeeb550"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libgphoto2"
  depends_on "popt"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphoto2 -v")
  end
end
