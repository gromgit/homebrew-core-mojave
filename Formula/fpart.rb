class Fpart < Formula
  desc "Sorts file trees and packs them into bags"
  homepage "https://github.com/martymac/fpart/"
  url "https://github.com/martymac/fpart/archive/fpart-1.5.1.tar.gz"
  sha256 "c353a28f48e4c08f597304cb4ebb88b382f66b7fabfc8d0328ccbb0ceae9220c"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fpart"
    sha256 cellar: :any_skip_relocation, mojave: "3e631967333489821b28c162616df8bdfed894cb2b56d9667ca2e97f53bc1576"
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
