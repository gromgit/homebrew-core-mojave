class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.4.2.tar.gz"
  sha256 "a38f507dea8aaa8f260f54ebc1de1a71e5adca416219f603cda3e3002960173c"
  license "GPL-2.0"

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/socat"
    sha256 cellar: :any, mojave: "d0fab00f274e290891f5e5cf7cf0b51146b610e621666fe98748a3b0fa9af17f"
  end

  depends_on "openssl@1.1"
  depends_on "readline"

  # Fix `error: use of undeclared identifier 'TCP_INFO'`
  # Remove in the next release
  patch :DATA

  def install
    system "./configure", *std_configure_args, "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end

__END__
diff --git a/filan.c b/filan.c
index 3465f7c..77c22a4 100644
--- a/filan.c
+++ b/filan.c
@@ -905,6 +905,7 @@ int tcpan(int fd, FILE *outfile) {
 #if WITH_TCP

 int tcpan2(int fd, FILE *outfile) {
+#ifdef TCP_INFO
    struct tcp_info tcpinfo;
    socklen_t tcpinfolen = sizeof(tcpinfo);
    int result;
@@ -930,6 +931,8 @@ int tcpan2(int fd, FILE *outfile) {
    // fprintf(outfile, "%s={%u}\t", "TCPI_", tcpinfo.tcpi_);

    return 0;
+#endif
+   return -1;
 }

 #endif /* WITH_TCP */
