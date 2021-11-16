class Udns < Formula
  desc "DNS resolver library"
  homepage "https://www.corpit.ru/mjt/udns.html"
  url "https://www.corpit.ru/mjt/udns/udns-0.4.tar.gz"
  sha256 "115108dc791a2f9e99e150012bcb459d9095da2dd7d80699b584ac0ac3768710"

  bottle do
    sha256 cellar: :any, catalina:    "18ac00a1a30fea027e398558edf149e464712c94fa68242740cc8e086e1ec036"
    sha256 cellar: :any, mojave:      "ce9ffcdbc08861f382e251d66293c4de690e5bffe1ca3015909332b71ea306c8"
    sha256 cellar: :any, high_sierra: "806e631f04904c4e550e3397a6519ee1803cb3cbef916967f42aed331e875afa"
    sha256 cellar: :any, sierra:      "8fbcc7a26f6be81abfe4766e9efc012c720938e8ea9dc9f20497cb82b101e659"
    sha256 cellar: :any, el_capitan:  "59939957b47912ebb286426391a4e2c904ecc416e9de18dc8c0a74052ac82ffe"
    sha256 cellar: :any, yosemite:    "342aff7270a4251655eb7cfc538b39db1805cfe965ada5cad1a2819b727d9107"
  end

  disable! date: "2020-12-08", because: :unmaintained

  # Build target for dylib. See:
  # https://www.corpit.ru/pipermail/udns/2011q3/000154.html
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/udns/0.4.patch"
    sha256 "4c3de5d04f93e7d7a9777b3baf3905707199fce9c08840712ccb2fb5fd6d90f9"
  end

  def install
    system "./configure"
    system "make"
    system "make", "dylib"

    bin.install "dnsget", "rblcheck"
    doc.install "NOTES", "TODO", "ex-rdns.c"
    include.install "udns.h"
    lib.install "libudns.a", "libudns.0.dylib", "libudns.dylib"
    man1.install "dnsget.1", "rblcheck.1"
    man3.install "udns.3"
  end
end
