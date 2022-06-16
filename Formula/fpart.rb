class Fpart < Formula
  desc "Sorts file trees and packs them into bags"
  homepage "https://github.com/martymac/fpart/"
  url "https://github.com/martymac/fpart/archive/fpart-1.5.0.tar.gz"
  sha256 "64aa6dcb519a9ce60e174ece9e390839d90ea3ad4d7b43d30e1b6de681918b6c"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fpart"
    sha256 cellar: :any_skip_relocation, mojave: "833e6f4d2e24888f006eebaaf7f01bc3d63113eb79a5ed377f963c2bc39621fb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"myfile1").write("")
    (testpath/"myfile2").write("")
    system bin/"fpart", "-n", "2", "-o", (testpath/"mypart"), (testpath/"myfile1"), (testpath/"myfile2")
    assert_predicate testpath/"mypart.1", :exist?
    assert_predicate testpath/"mypart.2", :exist?
    refute_predicate testpath/"mypart.0", :exist?
    refute_predicate testpath/"mypart.3", :exist?
  end
end
