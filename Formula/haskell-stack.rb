class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git", branch: "master"

  stable do
    url "https://github.com/commercialhaskell/stack/archive/v2.7.5.tar.gz"
    sha256 "7e77a91c9e2366b6be292188c1a36c96f8830f8a5f4a079fae7f73b9b0d2c8b6"
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/haskell-stack"
    sha256 cellar: :any_skip_relocation, mojave: "bdbb0515df10e7669408d07be81f6b03f812ae2b3628c8abb84b246341d13a00"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  # All ghc versions before 9.2.1 requires LLVM Code Generator as a backend on
  # ARM. GHC 8.10.7 user manual recommend use LLVM 9 through 12 and we met some
  # unknown issue with LLVM 13 before so conservatively use LLVM 12 here.
  #
  # References:
  #   https://downloads.haskell.org/~ghc/8.10.7/docs/html/users_guide/8.10.7-notes.html
  #   https://gitlab.haskell.org/ghc/ghc/-/issues/20559
  depends_on "llvm@12" if Hardware::CPU.arm?

  uses_from_macos "zlib"

  def install
    # https://github.com/JustusAdam/mustache/issues/41
    cabal_install_constraints = ["--constraint=mustache^>=2.3.1"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, *cabal_install_constraints

    bin.env_script_all_files libexec, PATH: "${PATH}:#{Formula["llvm@12"].opt_bin}" if Hardware::CPU.arm?
  end

  test do
    system bin/"stack", "new", "test"
    assert_predicate testpath/"test", :exist?
    assert_match "# test", File.read(testpath/"test/README.md")
  end
end
