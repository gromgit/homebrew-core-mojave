# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/legacy-homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.2.5.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.2.5.tar.gz"
  # This mirror needs to be manually created at `archive.org`.
  mirror "https://archive.org/download/xz-5.2.5.tar.gz/xz-5.2.5.tar.gz"
  mirror "http://archive.org/download/xz-5.2.5.tar.gz/xz-5.2.5.tar.gz"
  sha256 "f6f4910fd033078738bd82bfba4f49219d03b17eb0794eb91efbae419f4aba10"
  license all_of: [
    :public_domain,
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
  ]
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xz"
    rebuild 1
    sha256 mojave: "05fa2ecbd58a9d20bb535c6e5a1d15e42847acb6abd8e576f53a1a9c678a49f5"
  end

  # Fix arbitrary-file-write vulnerability in `xzgrep`.
  # https://seclists.org/oss-sec/2022/q2/18
  patch do
    url "https://tukaani.org/xz/xzgrep-ZDI-CAN-16587.patch"
    sha256 "98c6cb1042284fe704ec30083f3fc87364ce9ed2ea51f62bbb0ee9d3448717ec"
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
