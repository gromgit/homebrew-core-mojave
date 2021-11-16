class Pngpaste < Formula
  desc "Paste PNG into files"
  homepage "https://github.com/jcsalterego/pngpaste"
  url "https://github.com/jcsalterego/pngpaste/archive/0.2.3.tar.gz"
  sha256 "6221201cb05191855f0d2707ce7f4055f6e1330de8efc09d386be2a6629f543b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1199369118afc2095238084d9b632fc8d277b17d4a73d2edf40582e4d329614f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d28443efa53d8c51e0ba85a6985506cc21aad15a346df76ff04c2eea0acd33ff"
    sha256 cellar: :any_skip_relocation, monterey:       "e9a350b69811aa02e6b01d906cc184f35a8806e322bf62430b81bff8a6d27fd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "20d394d6036f0ffe382b36151c15d3ea9b20ce9d1e5fe6166ce11546c5e871f4"
    sha256 cellar: :any_skip_relocation, catalina:       "692e8f099ee7426310daa078d6bf2103b763b4549804f1775a5238acb1ead616"
    sha256 cellar: :any_skip_relocation, mojave:         "b67e349eaa3680c7be1746511a8a934e04320182d9396e75ca1936398d746779"
    sha256 cellar: :any_skip_relocation, high_sierra:    "eed393d2dbd516f60bdaa445df330a140853bee95cd49b0c3730345f57136676"
  end

  depends_on :macos

  def install
    system "make", "all"
    bin.install "pngpaste"
  end

  test do
    png = test_fixtures("test.png")
    system "osascript", "-e", "set the clipboard to POSIX file (\"#{png}\")"
    system bin/"pngpaste", "test.png"
    assert_predicate testpath/"test.png", :exist?
  end
end
