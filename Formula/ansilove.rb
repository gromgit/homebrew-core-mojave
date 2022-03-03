class Ansilove < Formula
  desc "ANSI/ASCII art to PNG converter"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/ansilove/releases/download/4.1.6/ansilove-4.1.6.tar.gz"
  sha256 "acc3d6431cdb53e275e5ddfc71de5f27df2f2c5ecc46dc8bb62be9e6f15a1cd0"
  license "BSD-2-Clause"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ansilove"
    rebuild 1
    sha256 cellar: :any, mojave: "bb7fdde76443542d647120e79845d956c1b23d19fcb698f239fcf8be3297752e"
  end

  depends_on "cmake" => :build
  depends_on "gd"

  resource "libansilove" do
    url "https://github.com/ansilove/libansilove/releases/download/1.2.9/libansilove-1.2.9.tar.gz"
    sha256 "88057f7753bf316f9a09ed15721b9f867ad9f5654c0b49af794d8d98b9020a66"
  end

  def install
    resource("libansilove").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/burps/bs-ansilove.ans" => "test.ans"
  end

  test do
    output = shell_output("#{bin}/ansilove -o #{testpath}/output.png #{pkgshare}/test.ans")
    assert_match "Font: 80x25", output
    assert_match "Id: SAUCE v00", output
    assert_match "Tinfos: IBM VGA", output
    assert_predicate testpath/"output.png", :exist?
  end
end
