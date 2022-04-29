class Dict < Formula
  desc "Dictionary Server Protocol (RFC2229) client"
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/dictd/dictd-1.13.1/dictd-1.13.1.tar.gz"
  sha256 "e4f1a67d16894d8494569d7dc9442c15cc38c011f2b9631c7f1cc62276652a1b"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dict"
    rebuild 2
    sha256 mojave: "c7519f60acc4485db1b93a3c26f23886b84738746a25645c609c0203b3279039"
  end

  depends_on "libtool" => :build
  depends_on "libmaa"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  def install
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
    (prefix+"etc/dict.conf").write <<~EOS
      server localhost
      server dict.org
    EOS
  end
end
