class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  url "https://hackage.haskell.org/package/mighttpd2-4.0.2/mighttpd2-4.0.2.tar.gz"
  sha256 "1d4dc43b96a3064a8c0b752f71591cb04d769b76e3b922a5ea3529057d530960"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mighttpd2"
    sha256 cellar: :any_skip_relocation, mojave: "db9a6f935edf39e80af041286f929a0c77df98d392900fbea5ea42f08d91040f"
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
