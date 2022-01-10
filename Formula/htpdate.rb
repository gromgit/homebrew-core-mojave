class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://www.vervest.org/htp/archive/c/htpdate-1.3.1.tar.gz"
  sha256 "f6fb63b18a0d836fda721ae5655ae0b87055db1b582e98c4700f64e1ba5e2d5a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.vervest.org/htp/?download"
    regex(/href=.*?htpdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/htpdate"
    sha256 cellar: :any_skip_relocation, mojave: "77e3954435b34f4b6aa8a35ab020ae0761ae384b39ced636b2d048d3b8ff9280"
  end

  # https://github.com/twekkel/htpdate/pull/9
  # remove in next release
  patch :DATA

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{sbin}/htpdate", "-q", "-d", "-u", ENV["USER"], "example.org"
  end
end

__END__
diff --git a/htpdate.c b/htpdate.c
index e25bb3c..fbed343 100644
--- a/htpdate.c
+++ b/htpdate.c
@@ -52,7 +52,7 @@
 #include <pwd.h>
 #include <grp.h>

-#if defined __NetBSD__ || defined __FreeBSD__
+#if defined __NetBSD__ || defined __FreeBSD__ || defined __APPLE__
 #define adjtimex ntp_adjtime
 #endif
