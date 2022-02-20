class Wiggle < Formula
  desc "Program for applying patches with conflicting changes"
  homepage "https://github.com/neilbrown/wiggle"
  url "https://github.com/neilbrown/wiggle/archive/refs/tags/v1.3.tar.gz"
  sha256 "ff92cf0133c1f4dce33563e263cb30e7ddb6f4abdf86d427b1ec1490bec25afa"
  license "GPL-2.0"

  livecheck do
    url "https://neil.brown.name/wiggle/"
    regex(/href=.*?wiggle[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wiggle"
    sha256 cellar: :any_skip_relocation, mojave: "d0ade4b19e692423d9048869388f395d23cf90efada72e1c7f044925cb26f103"
  end

  def install
    system "make", "OptDbg=#{ENV.cflags}", "wiggle", "wiggle.man", "test"
    bin.install "wiggle"
    man1.install "wiggle.1"
  end

  test do
    system "#{bin}/wiggle", "--version"
  end
end
