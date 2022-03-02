class Fasttext < Formula
  desc "Library for fast text representation and classification"
  homepage "https://fasttext.cc"
  url "https://github.com/facebookresearch/fastText/archive/v0.9.2.tar.gz"
  sha256 "7ea4edcdb64bfc6faaaec193ef181bdc108ee62bb6a04e48b2e80b639a99e27e"
  license "MIT"
  head "https://github.com/facebookresearch/fastText.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fasttext"
    rebuild 1
    sha256 cellar: :any, mojave: "796bbafa28a86862f3343e0c377d455dbc2c54ebef303d4b6b50c1a56188d947"
  end


  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"trainingset").write("__label__brew brew")
    system "#{bin}/fasttext", "supervised", "-input", "trainingset", "-output", "model"
    assert_predicate testpath/"model.bin", :exist?
  end
end
