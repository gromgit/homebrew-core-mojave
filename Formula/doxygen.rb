class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.9.5.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.5/doxygen-1.9.5.src.tar.gz"
  sha256 "55b454b35d998229a96f3d5485d57a0a517ce2b78d025efb79d57b5a2e4b2eec"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/doxygen"
    sha256 cellar: :any_skip_relocation, mojave: "5d9f6517d5beda75903ace77a5b7d2b28a52d1d2f074e775fa035e7af6dac044"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "python@3.10" => :build # Fails to build with macOS Python3
  uses_from_macos "flex" => :build, since: :big_sur

  on_linux do
    depends_on "gcc"
  end

  # Need gcc>=7.2. See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66297
  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build", "-Dbuild_doc=1", *std_cmake_args
    man1.install buildpath.glob("build/man/*.1")
  end

  test do
    system bin/"doxygen", "-g"
    system bin/"doxygen", "Doxyfile"
  end
end
