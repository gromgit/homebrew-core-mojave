class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://cab.spbu.ru/software/spades/"
  url "https://cab.spbu.ru/files/release3.15.4/SPAdes-3.15.4.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.15.4/SPAdes-3.15.4.tar.gz"
  sha256 "3b241c528a42a8bdfdf23e5bf8f0084834790590d08491decea9f0f009d8589f"
  license "GPL-2.0-only"

  livecheck do
    url "https://cab.spbu.ru/files/?C=M&O=D"
    regex(%r{href=.*?release(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/spades"
    sha256 cellar: :any_skip_relocation, mojave: "995095460ea143cdc70920c3a6a04acb6b947653bf9368e431f00f3444e3edc0"
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
