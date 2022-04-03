class Icdiff < Formula
  include Language::Python::Shebang

  desc "Improved colored diff"
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/release-2.0.4.tar.gz"
  sha256 "ec21632b64159990a1bcedc8b25f96b476e7a6d9e18b75422420c0ae9b694eac"
  license "PSF-2.0"
  revision 1
  head "https://github.com/jeffkaufman/icdiff.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/icdiff"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "2fee1aee1e7ac56daa5f1f59dd2473773bd018b16a4609c44540fbae4235ae9d"
  end

  depends_on "python@3.10"

  def install
    rewrite_shebang detected_python_shebang, "icdiff"
    bin.install "icdiff", "git-icdiff"
  end

  test do
    (testpath/"file1").write "test1"
    (testpath/"file2").write "test2"
    system "#{bin}/icdiff", "file1", "file2"
    system "git", "init"
    system "#{bin}/git-icdiff"
  end
end
