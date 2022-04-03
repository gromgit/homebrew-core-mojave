class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.34.6.tar.gz"
  sha256 "c2a6dc1f3db7bd97ef34d1f40b51d81e6f3775a99082c2d5186abf8f88e48e62"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hpack"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "5fcfecf75f0186f647150c2a8829ce8e232cca295751648bd85c26c4a7f26bd7"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  # Testing hpack is complicated by the fact that it is not guaranteed
  # to produce the exact same output for every version.  Hopefully
  # keeping this test maintained will not require too much churn, but
  # be aware that failures here can probably be fixed by tweaking the
  # expected output a bit.
  test do
    (testpath/"package.yaml").write <<~EOS
      name: homebrew
      dependencies: base
      library:
        exposed-modules: Homebrew
    EOS
    expected = <<~EOS
      name:           homebrew
      version:        0.0.0
      build-type:     Simple

      library
        exposed-modules:
            Homebrew
        other-modules:
            Paths_homebrew
        build-depends:
            base
        default-language: Haskell2010
    EOS

    system "#{bin}/hpack"

    # Skip the first lines because they contain the hpack version number.
    assert_equal expected, (testpath/"homebrew.cabal").read.lines[6..].join
  end
end
