class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/3.1.2.tar.gz"
  sha256 "464bc639bb0551435e606841db79fa97e044695f7c1062caf07dd3713dc2a09f"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dssim"
    sha256 cellar: :any_skip_relocation, mojave: "1a8d094c5faebfef3bd13484b9add7a00fdfce9670eadfb7ab2e9d7eb012da26"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  # build patch, commit ref,
  # https://github.com/kornelski/dssim/commit/5039fa8c96d4a0ceac207968b3ef15819822cf54
  # remove in next release
  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end

__END__
diff --git a/src/lib.rs b/src/lib.rs
index c04be07..319dc7f 100644
--- a/src/lib.rs
+++ b/src/lib.rs
@@ -8,7 +8,7 @@ use load_image::*;
 use std::path::Path;

 fn load(attr: &Dssim, path: &Path) -> Result<DssimImage<f32>, lodepng::Error> {
-    let img = load_image::load_path(path, false)?;
+    let img = load_image::load_path(path)?;
     Ok(match img.bitmap {
         ImageData::RGB8(ref bitmap) => attr.create_image(&Img::new(bitmap.to_rgblu(), img.width, img.height)),
         ImageData::RGB16(ref bitmap) => attr.create_image(&Img::new(bitmap.to_rgblu(), img.width, img.height)),
