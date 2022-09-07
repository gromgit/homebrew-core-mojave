class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/v0.5.2.tar.gz"
  sha256 "29172a43c7a4f41e5809d8c40cb76b798a0d01dfc9f5340b160a405b89b3b182"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rgbds"
    rebuild 3
    sha256 cellar: :any, mojave: "9ed3c56662ee153522bb32475edcf5256996f14bb3ee1827c401ada4a47713f6"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"

  resource "rgbobj" do
    url "https://github.com/gbdev/rgbobj/archive/refs/tags/v0.1.0.tar.gz"
    sha256 "359a3504dc5a5f7812dfee602a23aec80163d1d9ec13f713645b5495aeef2a9b"

    # Fix support for clap 3.2+. Remove in the next release.
    # Issue ref: https://github.com/gbdev/rgbobj/issues/4
    patch do
      url "https://github.com/gbdev/rgbobj/commit/b4e1fe42dbc297d67d67ed17004a3f6956de199f.patch?full_index=1"
      sha256 "27aceed0020c7561e8259308df0868d19e0b7f21ad5e0f2a389d591e8b60027d"
    end
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "mandir=#{man}"
    resource("rgbobj").stage do
      system "cargo", "install", *std_cargo_args
      man1.install "rgbobj.1"
    end
    zsh_completion.install Dir["contrib/zsh_compl/_*"]
    bash_completion.install Dir["contrib/bash_compl/_*"]
  end

  test do
    # Based on https://github.com/rednex/rgbds/blob/HEAD/test/asm/assert-const.asm
    (testpath/"source.asm").write <<~EOS
      SECTION "rgbasm passing asserts", ROM0[0]
      Label:
        db 0
        assert @
    EOS
    system bin/"rgbasm", "-o", "output.o", "source.asm"
    system bin/"rgbobj", "-A", "-s", "data", "-p", "data", "output.o"
  end
end
