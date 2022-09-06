class Memcacheq < Formula
  desc "Queue service for memcache"
  homepage "https://code.google.com/archive/p/memcacheq/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcacheq/memcacheq-0.2.0.tar.gz"
  sha256 "b314c46e1fb80d33d185742afe3b9a4fadee5575155cb1a63292ac2f28393046"
  license "BSD-3-Clause"
  revision 5

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/memcacheq"
    rebuild 1
    sha256 cellar: :any, mojave: "1b3260471ce7f3464e1650fd810b9ba770d90bba05e4b286d67579883bfded89"
  end

  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "libevent"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-threads"
    system "make", "install"
  end
end
