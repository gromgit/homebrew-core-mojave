class Jpegrescan < Formula
  desc "Losslessly shrink any JPEG file"
  homepage "https://github.com/kud/jpegrescan"
  url "https://github.com/kud/jpegrescan/archive/1.1.0.tar.gz"
  sha256 "a8522e971d11c904f4b61af665c3be800f26404e2b14f5f80c675b4a72a42b32"
  head "https://github.com/kud/jpegrescan.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jpegrescan"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "eef4b8279e4d63a3e68a83a365d9cecb54ce8464ce94d89b4e4089c80e4b3034"
  end

  depends_on "jpeg"

  def install
    bin.install "jpegrescan"
  end

  test do
    system bin/"jpegrescan", "-v", test_fixtures("test.jpg"), testpath/"out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
