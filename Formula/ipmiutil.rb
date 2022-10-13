class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.1.8.tar.gz"
  sha256 "b14357b9723e38a19c24df2771cff63d5f15f8682cd8a5b47235044b767b1888"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "GPL-2.0-or-later"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ipmiutil"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "d1db80754c3296c2194880c926124134660b6181493bed9a31b4b6a96dc3a0b5"
  end

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "renameutils", because: "both install `icmd` binaries"

  def install
    # Darwin does not exist only on PowerPC
    if OS.mac?
      inreplace "configure.ac", "test \"$archp\" = \"powerpc\"", "true"
      system "autoreconf", "--force", "--install", "--verbose"
    end

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-lanplus",
                          "--enable-sha256",
                          "--enable-gpl"

    system "make", "TMPDIR=#{ENV["TMPDIR"]}"
    # DESTDIR is needed to make everything go where we want it.
    system "make", "prefix=/",
                   "DESTDIR=#{prefix}",
                   "varto=#{var}/lib/#{name}",
                   "initto=#{etc}/init.d",
                   "sysdto=#{prefix}/#{name}",
                   "install"
  end

  test do
    system "#{bin}/ipmiutil", "delloem", "help"
  end
end
