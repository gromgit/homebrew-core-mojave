class Unyaffs < Formula
  desc "Extract files from a YAFFS2 filesystem image"
  homepage "https://packages.debian.org/sid/unyaffs"
  url "https://deb.debian.org/debian/pool/main/u/unyaffs/unyaffs_0.9.7.orig.tar.gz"
  sha256 "099ee9e51046b83fe8555d7a6284f6fe4fbae96be91404f770443d8129bd8775"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://deb.debian.org/debian/pool/main/u/unyaffs/"
    regex(/href=.*?unyaffs[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/unyaffs"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "68296422811e0e3c065b8f0c2f91f6ce6781f6a42ac188b6ab9d4e4869471172"
  end

  def install
    system "make"
    bin.install "unyaffs"
    man1.install "unyaffs.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unyaffs -V")
  end
end
