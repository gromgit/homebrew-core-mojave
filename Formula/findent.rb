class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.2.3.tar.gz"
  sha256 "1a67c3fa684072942bd5f0696158ababb1a7198d32e686ca8c1fb74f85f5d745"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/findent"
    sha256 cellar: :any_skip_relocation, mojave: "9152af1c5eb2682c3d1efbbe87edb3f7bda6157de31afe35e4bc94e7159a4759"
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
