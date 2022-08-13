class Libgsm < Formula
  desc "Lossy speech compression library"
  homepage "http://www.quut.com/gsm/"
  url "http://www.quut.com/gsm/gsm-1.0.22.tar.gz"
  sha256 "f0072e91f6bb85a878b2f6dbf4a0b7c850c4deb8049d554c65340b3bf69df0ac"
  license "TU-Berlin-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?gsm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libgsm"
    sha256 cellar: :any, mojave: "efdc730bb3cba8631ad34e542355bc1ef33faf03abbc29a93c50196d84dee611"
  end

  def install
    # Only the targets for which a directory exists will be installed
    bin.mkpath
    lib.mkpath
    include.mkpath
    man1.mkpath
    man3.mkpath

    arflags = if OS.mac?
      %W[
        -dynamiclib
        -compatibility_version #{version.major}
        -current_version #{version}
        -install_name #{lib/shared_library("libgsm", version.major.to_s)}
      ]
    else
      ["-shared"]
    end
    arflags << "-o"

    args = [
      "INSTALL_ROOT=#{prefix}",
      "GSM_INSTALL_INC=#{include}",
      "GSM_INSTALL_MAN=#{man3}",
      "TOAST_INSTALL_MAN=#{man1}",
      "LN=ln -s",
      "AR=#{ENV.cc}",
      "ARFLAGS=#{arflags.join(" ")}",
      "RANLIB=true",
      "LIBGSM=$(LIB)/#{shared_library("libgsm", version.to_s)}",
    ]
    args << "CC=#{ENV.cc} -fPIC" if OS.linux?

    # We need to `make all` to avoid a parallelisation error.
    system "make", "all", *args
    system "make", "install", *args

    # Our shared library is erroneously installed as `libgsm.a`
    lib.install lib/"libgsm.a" => shared_library("libgsm", version.to_s)
    lib.install_symlink shared_library("libgsm", version.to_s) => shared_library("libgsm")
    lib.install_symlink shared_library("libgsm", version.to_s) => shared_library("libgsm", version.major.to_s)
    lib.install_symlink shared_library("libgsm", version.to_s) => shared_library("libgsm", version.major_minor.to_s)

    # Build static library
    system "make", "clean"
    system "make", "./lib/libgsm.a"
    lib.install "lib/libgsm.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gsm.h>

      int main()
      {
        gsm g = gsm_create();
        if (g == 0)
        {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgsm", "-o", "test"
    system "./test"
  end
end
