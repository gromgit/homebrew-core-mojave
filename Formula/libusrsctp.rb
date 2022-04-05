class Libusrsctp < Formula
  desc "Portable SCTP userland stack"
  homepage "https://github.com/sctplab/usrsctp"
  url "https://github.com/sctplab/usrsctp/archive/0.9.5.0.tar.gz"
  sha256 "260107caf318650a57a8caa593550e39bca6943e93f970c80d6c17e59d62cd92"
  license "BSD-3-Clause"
  head "https://github.com/sctplab/usrsctp.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libusrsctp"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "8b01fff5871799e0c0731107d7d1227e238484bac3d4cb036c4e86ea28e6c4c2"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <unistd.h>
      #include <usrsctp.h>
      int main() {
        usrsctp_init(0, NULL, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lusrsctp", "-lpthread", "-o", "test"
    system "./test"
  end
end
