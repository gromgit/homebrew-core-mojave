class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-2.0.1.tar.gz"
  sha256 "2ed963eeef5517f7be921790ef0cde13c7bcac172ac14ce5818d84a261cc3b31"
  license "LGPL-3.0-or-later"
  head "https://github.com/algernon/riemann-c-client.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/riemann-client"
    sha256 cellar: :any, mojave: "09ab7c53e2269ac1518f242daf28a012c3aa04c4a34b960680ce1d3205f200d3"
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
