class Duti < Formula
  desc "Select default apps for documents and URL schemes on macOS"
  homepage "https://github.com/moretension/duti/"
  url "https://github.com/moretension/duti/archive/duti-1.5.4.tar.gz"
  sha256 "3f8f599899a0c3b85549190417e4433502f97e332ce96cd8fa95c0a9adbe56de"
  license :public_domain
  revision 1
  head "https://github.com/moretension/duti.git", branch: "master"

  livecheck do
    url :stable
    regex(/^duti[._-]v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/duti"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "443a1354fff7ff14fae0e74fd64805815167259e19b90962ee3561da1e4f1028"
  end


  depends_on "autoconf" => :build
  depends_on :macos

  # Fix compilation on macOS 10.14 Mojave
  patch do
    url "https://github.com/moretension/duti/commit/825b5e6a92770611b000ebdd6e3d3ef8f47f1c47.patch?full_index=1"
    sha256 "0f6013b156b79aa498881f951172bcd1ceac53807c061f95c5252a8d6df2a21a"
  end

  # Fix compilation on macOS >= 10.15
  patch do
    url "https://github.com/moretension/duti/commit/4a1f54faf29af4f125134aef3a47cfe05c7755ff.patch?full_index=1"
    sha256 "7c90efd1606438f419ac2fa668c587f2a63ce20673c600ed0c45046fd8b14ea6"
  end

  # Fix compilation on Monterey
  patch do
    url "https://github.com/moretension/duti/commit/ec195e261f8a48a1a18e262a2b1f0ef26a0bc1ee.patch?full_index=1"
    sha256 "dec21aeea7f31c1a2122a01b44c13539af48840b181a80cecb4653591a9b0f9d"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "com.apple.TextEdit", shell_output("#{bin}/duti -l public.text"),
                 "TextEdit not found among the handlers for public.text"
  end
end
