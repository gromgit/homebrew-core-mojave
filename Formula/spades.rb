class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://cab.spbu.ru/software/spades/"
  url "https://cab.spbu.ru/files/release3.15.5/SPAdes-3.15.5.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.15.5/SPAdes-3.15.5.tar.gz"
  sha256 "155c3640d571f2e7b19a05031d1fd0d19bd82df785d38870fb93bd241b12bbfa"
  license "GPL-2.0-only"

  livecheck do
    url "https://cab.spbu.ru/files/?C=M&O=D"
    regex(%r{href=.*?release(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/spades"
    sha256 cellar: :any_skip_relocation, mojave: "68c6368467d012c551efcf40bc2752625b1655b30064a44dd4e8a0e5085dc0ca"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "jemalloc"
    depends_on "readline"
  end

  def install
    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
