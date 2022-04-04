class Lepton < Formula
  desc "Tool and file format for losslessly compressing JPEGs"
  homepage "https://github.com/dropbox/lepton"
  url "https://github.com/dropbox/lepton/archive/1.2.1.tar.gz"
  sha256 "c4612dbbc88527be2e27fddf53aadf1bfc117e744db67e373ef8940449cdec97"
  license "Apache-2.0"
  head "https://github.com/dropbox/lepton.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lepton"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "1fe0df04da7e8de022a2b04d4097e32ce5a13ee58440fc9c36275a53643aef7d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.jpg"), "test.jpg"
    system "#{bin}/lepton", "test.jpg", "compressed.lep"
    system "#{bin}/lepton", "compressed.lep", "test_restored.jpg"
    cmp "test.jpg", "test_restored.jpg"
  end
end
