class PscPackage < Formula
  desc "Package manager for PureScript based on package sets"
  homepage "https://psc-package.readthedocs.io"
  url "https://github.com/purescript/psc-package/archive/v0.6.2.tar.gz"
  sha256 "96c3bf2c65d381c61eff3d16d600eadd71ac821bbe7db02acec1d8b3b6dbecfc"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 mojave: "f27baf8ae2f171b8f7236ee399bb9df7da423c4ef81b68d7e0ece78df850d204" # fake mojave
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "purescript"

  # Apply upstream patch to fix build. Remove with next release.
  patch do
    url "https://github.com/purescript/psc-package/commit/2817cfd7bbc29de790d2ab7bee582cd6167c16b5.patch?full_index=1"
    sha256 "e49585ff8127ccca0b35dc8a7caa04551de1638edfd9ac38e031d1148212091c"
  end

  # Another patch to fix build. See https://github.com/purescript/psc-package/pull/169.
  patch :DATA

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "Initializing new project in current directory", shell_output("#{bin}/psc-package init --set=master")
    package_json = (testpath/"psc-package.json").read
    package_hash = JSON.parse(package_json)
    assert_match "master", package_hash["set"]
    assert_match "Install complete", shell_output("#{bin}/psc-package install")
  end
end

__END__
diff --git a/app/Types.hs b/app/Types.hs
index e0a6b73..3614dab 100644
--- a/app/Types.hs
+++ b/app/Types.hs
@@ -10,6 +10,7 @@ module Types
 
 import           Control.Category ((>>>))
 import           Data.Aeson (FromJSON, ToJSON, FromJSONKey(..), ToJSONKey(..), ToJSONKeyFunction(..), FromJSONKeyFunction(..), parseJSON, toJSON, withText)
+import           Data.Aeson.Types (toJSONKeyText)
 import qualified Data.Aeson.Encoding as AesonEncoding
 import           Data.Char (isAscii, isLower, isDigit)
 import           Data.Text (Text)
@@ -34,9 +35,7 @@ fromText t =
 
 instance ToJSONKey PackageName where
   toJSONKey =
-    ToJSONKeyText
-      runPackageName
-      (AesonEncoding.text . runPackageName)
+    toJSONKeyText runPackageName
 
 instance FromJSONKey PackageName where
   fromJSONKey =
