class Enca < Formula
  desc "Charset analyzer and converter"
  homepage "https://cihar.com/software/enca/"
  url "https://dl.cihar.com/enca/enca-1.19.tar.gz"
  sha256 "4c305cc59f3e57f2cfc150a6ac511690f43633595760e1cb266bf23362d72f8a"
  license "GPL-2.0-only"
  head "https://github.com/nijel/enca.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?enca[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/enca"
    rebuild 1
    sha256 mojave: "b8afd1cd00e37b757e995b944390e7aa620da4d5c6c77a5426db1f2c6de7832f"
  end


  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    enca = "#{bin}/enca --language=none"
    assert_match "ASCII", pipe_output(enca, "Testing...")
    ucs2_text = pipe_output("#{enca} --convert-to=UTF-16", "Testing...")
    assert_match "UCS-2", pipe_output(enca, ucs2_text)
  end
end
