class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.24/hledger-1.24.tar.gz"
  sha256 "c01a0111c3d3cf51f6facd07fbc5b7d36d045a247f18a02b272144120b065ca5"
  license "GPL-3.0-or-later"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/download.html"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hledger"
    sha256 cellar: :any_skip_relocation, mojave: "31946deb1d1600ac51ce8e1dfdb08b64ba8e36e4da82938e1ead1eb8c6964b00"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.24/hledger-lib-1.24.tar.gz"
    sha256 "9496ed498c06f0eaf551092e5b533290be0fec48db2a053eaa1ccecab66458be"
  end

  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.24/hledger-ui-1.24.tar.gz"
    sha256 "2c65762ff976518603598f2624fe0789696b901172bbfafd496368e4ce311628"
  end

  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.24/hledger-web-1.24.tar.gz"
    sha256 "71e56feaa76143f0dfb13815ba0021b86fe152f7926a336faaa0113dc336f276"
  end

  def install
    (buildpath/"../hledger-lib").install resource("hledger-lib")
    (buildpath/"../hledger-ui").install resource("hledger-ui")
    (buildpath/"../hledger-web").install resource("hledger-web")
    cd ".." do
      system "stack", "update"
      (buildpath/"../stack.yaml").write <<~EOS
        resolver: lts-17.5
        compiler: ghc-#{Formula["ghc"].version}
        compiler-check: newer-minor
        packages:
        - hledger-#{version}
        - hledger-lib
        - hledger-ui
        - hledger-web
      EOS
      system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"

      man1.install Dir["hledger-*/*.1"]
      man5.install Dir["hledger-lib/*.5"]
      info.install Dir["hledger-*/*.info"]
    end
  end

  test do
    system "#{bin}/hledger", "test"
    system "#{bin}/hledger-ui", "--version"
    system "#{bin}/hledger-web", "--test"
  end
end
