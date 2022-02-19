class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/1.16.2.tar.gz"
  sha256 "ab253ef2cde8afc3f2ad9a30f6983f495e334bac6239364d2ec421d0d586a37a"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/basis_universal"
    sha256 cellar: :any_skip_relocation, mojave: "eadd30c69deb97e76727067fc74927dbb7c5f89596116bacf9cfa5c6ef108596"
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
