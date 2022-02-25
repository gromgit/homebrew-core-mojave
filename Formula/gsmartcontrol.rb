class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.4/gsmartcontrol-1.1.4.tar.bz2"
  sha256 "fc409f2b8a84cc40bb103d6c82401b9d4c0182d5a3b223c93959c7ad66191847"
  license any_of: ["GPL-2.0", "GPL-3.0"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gsmartcontrol"
    sha256 mojave: "4d64d4f3d9b97106da4de9b78c4c50789b78a35a371b5f3882238e17e3c96dd0"
  end

  depends_on "pkg-config" => :build
  depends_on "gtkmm3"
  depends_on "pcre"
  depends_on "smartmontools"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/gsmartcontrol", "--version"
  end
end
