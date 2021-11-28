class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  url "https://hackage.haskell.org/package/mighttpd2-4.0.0/mighttpd2-4.0.0.tar.gz"
  sha256 "5afc8acb4e268401dc19964b710230e5013399b8ad3baa7ae6d5e5802ad4ac42"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mighttpd2"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ecc9464cdf9a02163dcd85e2cc7efb9a565840b6302e882976017feae2087fc8"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "-ftls", *std_cabal_v2_args
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
