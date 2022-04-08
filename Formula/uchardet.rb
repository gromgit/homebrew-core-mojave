class Uchardet < Formula
  desc "Encoding detector library"
  homepage "https://www.freedesktop.org/wiki/Software/uchardet/"
  url "https://www.freedesktop.org/software/uchardet/releases/uchardet-0.0.7.tar.xz"
  sha256 "3fc79408ae1d84b406922fa9319ce005631c95ca0f34b205fad867e8b30e45b1"
  head "https://gitlab.freedesktop.org/uchardet/uchardet.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/uchardet"
    rebuild 1
    sha256 cellar: :any, mojave: "01da283600a3d3ed48c6124a746551140264e886817ced4f8c569ebcdb57ec9f"
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DCMAKE_INSTALL_NAME_DIR=#{lib}"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    assert_equal "ASCII", pipe_output("#{bin}/uchardet", "Homebrew").chomp
  end
end
