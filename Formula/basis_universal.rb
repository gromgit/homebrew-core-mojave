class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/1.16.3.tar.gz"
  sha256 "b89563aa5879eed20f56b9cfa03b52848e759531fd5a1d51a8f63c846f96c2ac"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/basis_universal"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "fcc196c4a5037440259120e2fdab15be5c609b2fbedb74806473129e16862aee"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/basisu", test_fixtures("test.png")
    assert_predicate testpath/"test.basis", :exist?
  end
end
