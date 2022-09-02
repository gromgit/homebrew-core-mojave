class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.2.1.tar.gz"
  sha256 "c010ce4d020ec77c055e0dea1f29a2f52815cb4debe052fd559cf09049fac702"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/findent"
    sha256 cellar: :any_skip_relocation, mojave: "b9cbefc6a62a046a76e3be5352467c34a310bc541a0464239de53c9d2e5d866e"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"test").install %w[test/progfree.f.in test/progfree.f.try.f.ref]
  end

  test do
    cp_r pkgshare/"test/progfree.f.in", testpath
    cp_r pkgshare/"test/progfree.f.try.f.ref", testpath
    flags = File.open(testpath/"progfree.f.in", &:readline).sub(/ *! */, "").chomp
    system "#{bin}/findent #{flags} < progfree.f.in > progfree.f.out.f90"
    assert_predicate testpath/"progfree.f.out.f90", :exist?
    assert compare_file(testpath/"progfree.f.try.f.ref", testpath/"progfree.f.out.f90")
  end
end
