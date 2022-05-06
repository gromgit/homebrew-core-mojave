class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  # 2.x series is in beta and shouldn't be upgraded to until it's stable
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "d74f86ada2329016068bc5a243268f1f555edd620b6a7d6ce89295e7d6cf18da"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mimalloc"
    sha256 cellar: :any, mojave: "2bf1dffcf459bcc424c183c929efdc4f48c25d5fcbc0ff86adc0bba24fda5875"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DMI_INSTALL_TOPLEVEL=ON"
      system "make"
      system "make", "install"
    end
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match "heap stats", shell_output("./test 2>&1")
  end
end
