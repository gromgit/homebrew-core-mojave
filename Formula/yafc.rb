class Yafc < Formula
  desc "Command-line FTP client"
  homepage "https://github.com/sebastinas/yafc"
  url "https://deb.debian.org/debian/pool/main/y/yafc/yafc_1.3.7.orig.tar.xz"
  sha256 "4b3ebf62423f21bdaa2449b66d15e8d0bb04215472cb63a31d473c3c3912c1e0"
  revision 4

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yafc"
    rebuild 1
    sha256 cellar: :any, mojave: "d5f4bb995520fd048a258afad6d6b4739270fc1f338853c9dab5e1ade5fce4da"
  end

  depends_on "pkg-config" => :build
  depends_on "libssh"
  depends_on "readline"

  on_linux do
    depends_on "libbsd"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    download_file = testpath/"gcc-10.2.0.tar.xz.sig"
    expected_checksum = Checksum.new("8e271266e0e3312bb1c384c48b01374e9c97305df781599760944e0a093fad38")
    output = pipe_output("#{bin}/yafc -W #{testpath} -a ftp://ftp.gnu.org/gnu/gcc/gcc-10.2.0/",
                         "get #{download_file.basename}", 0)
    assert_match version.to_s, output
    download_file.verify_checksum expected_checksum
  end
end
