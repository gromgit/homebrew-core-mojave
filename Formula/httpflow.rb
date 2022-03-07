class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP"
  homepage "https://github.com/six-ddc/httpflow"
  url "https://github.com/six-ddc/httpflow/archive/0.0.9.tar.gz"
  sha256 "2347bd416641e165669bf1362107499d0bc4524ed9bfbb273ccd3b3dd411e89c"
  license "MIT"
  head "https://github.com/six-ddc/httpflow.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/httpflow"
    rebuild 1
    sha256 cellar: :any, mojave: "17419b02cdd6c4d7bf738d3c657bad447669af4504280322b71c36e031c66ce4"
  end

  depends_on "pcre"

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "CXX=#{ENV.cxx}"
  end

  test do
    system "#{bin}/httpflow", "-h"
  end
end
