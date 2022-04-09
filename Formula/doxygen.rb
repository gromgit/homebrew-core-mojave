class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.org/"
  url "https://doxygen.nl/files/doxygen-1.9.3.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.3/doxygen-1.9.3.src.tar.gz"
  sha256 "f352dbc3221af7012b7b00935f2dfdc9fb67a97d43287d2f6c81c50449d254e0"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/doxygen"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "85833a3e2b1b88754d4e24219b8b70c26b002c8f40085e8263c63f79ee121e68"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build

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
    end
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
