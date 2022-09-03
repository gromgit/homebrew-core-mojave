class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.8.tar.gz"
  sha256 "09d9c1a53abe734e09762a5f848888f0491516c09cd341a1f9c039cd810d32a2"
  license "BSD-2-Clause"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sagittarius-scheme"
    rebuild 1
    sha256 cellar: :any, mojave: "2156ca50b86cf0a9a521686ac284cafccf48239dbbf10f5f25aba9845ef10db3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DODBC_LIBRARIES=odbc", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "4", shell_output("#{bin}/sagittarius -e '(display (+ 1 3))(exit)'")
  end
end
