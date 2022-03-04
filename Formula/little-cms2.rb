class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.13/lcms2-2.13.1.tar.gz"
  sha256 "d473e796e7b27c5af01bd6d1552d42b45b43457e7182ce9903f38bb748203b88"
  license "MIT"
  version_scheme 1

  # The Little CMS website has been redesigned and there's no longer a
  # "Download" page we can check for releases. As of writing this, checking the
  # "Releases" blog posts seems to be our best option and we just have to hope
  # that the post URLs, headings, etc. maintain a consistent format.
  livecheck do
    url "https://www.littlecms.com/categories/releases/"
    regex(%r{href=.*lcms2[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/little-cms2"
    rebuild 1
    sha256 cellar: :any, mojave: "eae886b6789cc3b0d08fda996e191a3c587405c1df9154c24ce55b466bc8640f"
  end

  depends_on "jpeg"
  depends_on "libtiff"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
