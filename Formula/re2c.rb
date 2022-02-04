class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/3.0/re2c-3.0.tar.xz"
  sha256 "b3babbbb1461e13fe22c630a40c43885efcfbbbb585830c6f4c0d791cf82ba0b"
  license :public_domain

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/re2c"
    sha256 mojave: "0abe92191404f3e5da8745e66de0c76bd850af6352911fcae017379901d1285e"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      unsigned int stou (const char * s)
      {
      #   define YYCTYPE char
          const YYCTYPE * YYCURSOR = s;
          unsigned int result = 0;

          for (;;)
          {
              /*!re2c
                  re2c:yyfill:enable = 0;

                  "\x00" { return result; }
                  [0-9]  { result = result * 10 + c; continue; }
              */
          }
      }
    EOS
    system bin/"re2c", "-is", testpath/"test.c"
  end
end
