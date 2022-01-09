class Bgpq3 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "http://snar.spb.ru/prog/bgpq3/"
  url "https://github.com/snar/bgpq3/archive/v0.1.36.1.tar.gz"
  sha256 "68d602434d072115b848f6047a7a29812d53c709835a4fbd0ba34dcc31553bcd"
  license "BSD-2-Clause"
  head "https://github.com/snar/bgpq3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bgpq3"
    sha256 cellar: :any_skip_relocation, mojave: "42b1ae08191ee6b930340d32b00b4512c20a3ae8211bddf098c6e2ca48ec3921"
  end

  # Makefile: upstream has been informed of the patch through email (multiple
  # times) but no plans yet to incorporate it https://github.com/snar/bgpq3/pull/2
  # there was discussion about this patch for 0.1.18 and 0.1.19 as well
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/bgpq3", "AS-ANY"
  end
end

__END__
--- a/Makefile.in
+++ b/Makefile.in
@@ -32,8 +32,8 @@
 install: bgpq3
 	if test ! -d @bindir@ ; then mkdir -p @bindir@ ; fi
 	${INSTALL} -c -s -m 755 bgpq3 @bindir@
-	if test ! -d @prefix@/man/man8 ; then mkdir -p @prefix@/man/man8 ; fi
-	${INSTALL} -m 644 bgpq3.8 @prefix@/man/man8
+	if test ! -d @mandir@/man8 ; then mkdir -p @mandir@/man8 ; fi
+	${INSTALL} -m 644 bgpq3.8 @mandir@/man8

 depend:
 	makedepend -- $(CFLAGS) -- $(SRCS)
