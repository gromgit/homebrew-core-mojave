class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-2.0.0.tar.gz"
  sha256 "36f3fd6e293d61791d288682340fe69a87af9a843410d9b4b8b4192226cdea5f"
  license "LGPL-3.0-or-later"
  head "https://github.com/algernon/riemann-c-client.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/riemann-client"
    sha256 cellar: :any, mojave: "f4ab131ffcb22e3f31a069c289f7115302fc8ee34fba57e890e6c6e7c35e6b99"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "json-c"
  depends_on "protobuf-c"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/riemann-client", "send", "-h"
  end
end
