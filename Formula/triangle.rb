class Triangle < Formula
  desc "Convert images to computer generated art using Delaunay triangulation"
  homepage "https://github.com/esimov/triangle"
  url "https://github.com/esimov/triangle/archive/v2.0.0.tar.gz"
  sha256 "071ba2a39b62e7914a233af74e7935ddb7a875bc2a5f193cd43862da65b1c516"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/triangle"
    sha256 cellar: :any_skip_relocation, mojave: "b9566246f42449f124c59c4dbab68b204e70ddf4394da59872973d338fb03b74"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", "#{bin}/triangle", "./cmd/triangle"
  end

  test do
    system "#{bin}/triangle", "-in", test_fixtures("test.png"), "-out", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
