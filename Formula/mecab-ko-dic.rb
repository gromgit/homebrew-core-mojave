class MecabKoDic < Formula
  desc "See mecab"
  homepage "https://bitbucket.org/eunjeon/mecab-ko-dic"
  url "https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-2.1.1-20180720.tar.gz"
  sha256 "fd62d3d6d8fa85145528065fabad4d7cb20f6b2201e71be4081a4e9701a5b330"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/href=.*?mecab-ko-dic[._-]v?(\d+(?:\.\d+)+-\d+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mecab-ko-dic"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "e9149e5ec1b85940657df3ed931d6ddbc83ea1a1e68767b9d27138c5d4ba451c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "mecab-ko"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-dicdir=#{lib}/mecab/dic/mecab-ko-dic"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To enable mecab-ko-dic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
        dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/mecab-ko-dic
    EOS
  end

  test do
    (testpath/"mecabrc").write <<~EOS
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/mecab-ko-dic
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "화학 이외의 것\n", 0)
  end
end
