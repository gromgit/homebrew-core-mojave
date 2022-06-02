class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.9.4.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.4/doxygen-1.9.4.src.tar.gz"
  sha256 "a15e9cd8c0d02b7888bc8356eac200222ecff1defd32f3fe05257d81227b1f37"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/doxygen"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "54b91420d7a0e32ff1a9d6c3ab26d35d9af672fe0d96867d3c617fb8c25cd414"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build, since: :big_sur
  uses_from_macos "python" => :build

  on_linux do
    depends_on "gcc"
  end

  # Need gcc>=7.2. See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66297
  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
      system "cmake", "-Dbuild_doc=1", "..", *std_cmake_args
      man1.install Dir["man/*.1"]
    end
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
