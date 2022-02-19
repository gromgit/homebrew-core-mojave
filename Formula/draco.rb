class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.5.1.tar.gz"
  sha256 "1e52f9d78f7f5d8c2d29e706dea751b2719fd795ee6e1e6259f6d5f8ac34666b"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/draco"
    sha256 cellar: :any_skip_relocation, mojave: "5b1368f44ce26bdaa359449ecefb9f2f82ff57a98bc81ce721046c726008b30c"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", * std_cmake_args
      system "make", "install"
    end
    pkgshare.install "testdata/cube_att.ply"
  end

  test do
    system "#{bin}/draco_encoder", "-i", "#{pkgshare}/cube_att.ply",
           "-o", "cube_att.drc"
    assert_predicate testpath/"cube_att.drc", :exist?
  end
end
