class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.9.tar.gz"
  sha256 "501ecb7f273669f4c8556e522221f15e2db0ca8542d90d82953912390e9498f8"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sagittarius-scheme"
    sha256 cellar: :any, mojave: "9fac25406de61c0a440c21319b9660900cb54b49ec6ce8c6ccb7aa8afd2ed01b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "zlib"

  def install
    # Work around build error on Apple Silicon by forcing little endian.
    # src/sagittarius/private/sagittariusdefs.h:200:3: error: Failed to detect endian
    ENV.append_to_cflags "-D_LITTLE_ENDIAN" if OS.mac? && Hardware::CPU.arm?

    system "cmake", "-S", ".", "-B", "build", "-DODBC_LIBRARIES=odbc", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "4", shell_output("#{bin}/sagittarius -e '(display (+ 1 3))(exit)'")
  end
end
