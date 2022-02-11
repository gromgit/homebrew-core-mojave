class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/1.16.tar.gz"
  sha256 "2d4d8f1be7c2f177409a22f467109e4695cd41a672e0cd228e4019fd2cefc4a9"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/basis_universal"
    sha256 cellar: :any_skip_relocation, mojave: "4f4b7801f438643a169a6cf0f0735ddcdb6433695a51c6343a4df131cfe610a7"
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
