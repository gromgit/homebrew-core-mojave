class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v1.1.0.tar.gz"
  sha256 "f9230b27c4a62f31223847bc485c51f3d960f8a09f36998dedb73358e1784b4e"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/baresip"
    sha256 mojave: "e9a44489ab69b8cc15945ad52ab11fa2793973e4b7ed310465dbe5ebc99012ba"
  end

  depends_on "libre"
  depends_on "librem"

  def install
    # baresip doesn't like the 10.11 SDK when on Yosemite
    if MacOS::Xcode.version.to_i >= 7
      ENV.delete("SDKROOT")
      ENV.delete("HOMEBREW_SDKROOT") if MacOS::Xcode.without_clt?
    end

    libre = Formula["libre"]
    librem = Formula["librem"]
    # NOTE: `LIBRE_SO` is a directory but `LIBREM_SO` is a shared library.
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}",
                              "LIBREM_PATH=#{librem.opt_prefix}",
                              "LIBREM_SO=#{librem.opt_lib/shared_library("librem")}",
                              "MOD_AUTODETECT=",
                              "USE_AVCAPTURE=1",
                              "USE_COREAUDIO=1",
                              "USE_G711=1",
                              "USE_OPENGL=1",
                              "USE_STDIO=1",
                              "USE_UUID=1",
                              "HAVE_GETOPT=1",
                              "V=1"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
