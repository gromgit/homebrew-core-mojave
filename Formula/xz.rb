# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/legacy-homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.2.7.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.2.7.tar.gz"
  mirror "https://archive.org/download/xz-5.2.7/xz-5.2.7.tar.gz"
  mirror "http://archive.org/download/xz-5.2.7/xz-5.2.7.tar.gz"
  sha256 "06327c2ddc81e126a6d9a78b0be5014b976a2c0832f492dcfc4755d7facf6d33"
  license all_of: [
    :public_domain,
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
  ]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xz"
    sha256 mojave: "0a5574ca65ed1851392a78bc3b20b2a93b83e61d67aabbbed65f8f43179b1a13"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.xz
    system bin/"xz", path
    refute_predicate path, :exist?

    # decompress: data.txt.xz -> data.txt
    system bin/"xz", "-d", "#{path}.xz"
    assert_equal original_contents, path.read
  end
end
