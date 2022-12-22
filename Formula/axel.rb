class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/axel-download-accelerator/axel"
  url "https://github.com/axel-download-accelerator/axel/releases/download/v2.17.11/axel-2.17.11.tar.xz"
  sha256 "580b2c18692482fd7f1e2b2819159484311ffc50f6d18924dceb80fd41d4ccf9"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/axel"
    rebuild 2
    sha256 cellar: :any, mojave: "aef0cefbae924c2ecd2d10912f30e486f9c29b9bfba37ac79b3d7094cbe0c1ea"
  end

  head do
    url "https://github.com/axel-download-accelerator/axel.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gawk" => :build

    resource "txt2man" do
      url "https://github.com/mvertes/txt2man/archive/refs/tags/txt2man-1.7.1.tar.gz"
      sha256 "4d9b1bfa2b7a5265b4e5cb3aebc1078323b029aa961b6836d8f96aba6a9e434d"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@3"

  def install
    if build.head?
      resource("txt2man").stage { (buildpath/"txt2man").install "txt2man" }
      ENV.prepend_path "PATH", buildpath/"txt2man"
      system "autoreconf", "--force", "--install", "--verbose"
    end
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_predicate testpath/"axel.tar.gz", :exist?
  end
end
