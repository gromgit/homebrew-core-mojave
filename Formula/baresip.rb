class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v2.5.1.tar.gz"
  sha256 "5ff4a3d85ce8fcdbac5391404d682ba843cbbc65b8827c6cd11727bcc209217a"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/baresip"
    sha256 mojave: "73ba09c5b6a48962a5c5d9f5f0dd294d15b66d649518f369bddfce7c132e13d1"
  end

  depends_on "libre"
  depends_on "librem"

  def install
    libre = Formula["libre"]
    librem = Formula["librem"]
    # NOTE: `LIBRE_SO` is a directory but `LIBREM_SO` is a shared library.
    args = %W[
      PREFIX=#{prefix}
      LIBRE_MK=#{libre.opt_share}/re/re.mk
      LIBRE_INC=#{libre.opt_include}/re
      LIBRE_SO=#{libre.opt_lib}
      LIBREM_PATH=#{librem.opt_prefix}
      LIBREM_SO=#{librem.opt_lib/shared_library("librem")}
      MOD_AUTODETECT=
      USE_G711=1
      USE_OPENGL=1
      USE_STDIO=1
      USE_UUID=1
      HAVE_GETOPT=1
      V=1
    ]
    if OS.mac?
      args << "USE_AVCAPTURE=1"
      args << "USE_COREAUDIO=1"
    end
    system "make", "install", *args
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
