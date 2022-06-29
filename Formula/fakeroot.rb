class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.29.orig.tar.gz"
  sha256 "8fbbafb780c9173e3ace4a04afbc1d900f337f3216883939f5c7db3431be7c20"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fakeroot"
    sha256 cellar: :any, mojave: "72a46c31d27f4027d2a9a558b35adbdf4d2b783a2a1cb240435e2dbfc37945ef"
  end

  # Needed to apply patches below. Remove when no longer needed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "libcap" => :build
  end

  # https://salsa.debian.org/clint/fakeroot/-/merge_requests/16
  patch do
    url "https://salsa.debian.org/clint/fakeroot/-/commit/e1a7af793e58bddd4bbd04cfb4d26687fbaa9bcf.diff"
    sha256 "60cfd8bbc416527981151237b7c403fba88975e97907a0ed5c31566d0cda078d"
  end

  # https://salsa.debian.org/clint/fakeroot/-/merge_requests/17
  patch :p0 do
    # The MR has a typo, so we use MacPorts' version.
    url "https://raw.githubusercontent.com/macports/macports-ports/0ffd857cab7b021f9dbf2cbc876d8025b6aefeff/sysutils/fakeroot/files/patch-message.h.diff"
    sha256 "6540eef1c31ffb4ed636c1f4750ee668d2effdfe308d975d835aa518731c72dc"
  end

  def install
    system "./bootstrap" # remove when patches are no longer needed

    args = ["--disable-silent-rules"]
    args << "--disable-static" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakeroot -v")
  end
end
