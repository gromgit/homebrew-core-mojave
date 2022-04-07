class Prips < Formula
  desc "Print the IP addresses in a given range"
  homepage "https://devel.ringlet.net/sysutils/prips/"
  url "https://devel.ringlet.net/files/sys/prips/prips-1.2.0.tar.xz"
  sha256 "de28d8a5a619a30d0b3c8a76f9c09c3529d197f3e74b04c8aa994096ab8349d4"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/current version .*?prips.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/prips"
    sha256 cellar: :any_skip_relocation, mojave: "f9fbae9e11ef278264eb7bca298070b73d21cafd3d24789d47dde39bc474bafc"
  end

  def install
    system "make"
    bin.install "prips"
    man1.install "prips.1"
  end

  test do
    assert_equal "127.0.0.0\n127.0.0.1",
      shell_output("#{bin}/prips 127.0.0.0/31").strip
  end
end
