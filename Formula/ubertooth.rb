class Ubertooth < Formula
  desc "Host tools for Project Ubertooth"
  homepage "https://github.com/greatscottgadgets/ubertooth/wiki"
  url "https://github.com/greatscottgadgets/ubertooth/releases/download/2020-12-R1/ubertooth-2020-12-R1.tar.xz"
  version "2020-12-R1"
  sha256 "93a4ce7af8eddcc299d65aff8dd3a0455293022f7fea4738b286353f833bf986"
  license "GPL-2.0-or-later"
  head "https://github.com/greatscottgadgets/ubertooth.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ubertooth"
    rebuild 1
    sha256 cellar: :any, mojave: "f68fbad4aedceb05022e7804605377b66ab56d770571d7bf7334b3ab1c7d8970"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libbtbb"
  depends_on "libusb"

  def install
    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # Most ubertooth utilities require an ubertooth device present.
    system "#{bin}/ubertooth-rx", "-i", "/dev/null"
  end
end
