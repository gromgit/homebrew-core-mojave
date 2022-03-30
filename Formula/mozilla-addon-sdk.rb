class MozillaAddonSdk < Formula
  desc "Create Firefox add-ons using JS, HTML, and CSS"
  homepage "https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons"
  url "https://archive.mozilla.org/pub/mozilla.org/labs/jetpack/addon-sdk-1.17.zip"
  sha256 "16e29d92214a556c8422db156b541fb8c47addfcb3cd879e0a4ca879d6a31f65"
  license "MPL-2.0"

  bottle do
    sha256 mojave: "f27baf8ae2f171b8f7236ee399bb9df7da423c4ef81b68d7e0ece78df850d204" # fake mojave
  end

  disable! date: "2021-03-24", because: :unsupported

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/cfx"
  end
end
