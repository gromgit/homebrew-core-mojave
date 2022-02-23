class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.5.2.tar.gz"
  sha256 "a887e311ec04a068ceca0bd6f3865083042334fbff26e65bc809e8978b2ce9cd"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/draco"
    sha256 cellar: :any_skip_relocation, mojave: "56c84325ffbecad986495f8f4235edfc88cc04fe1b848f06a5bbf0d4ff41d0c7"
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
