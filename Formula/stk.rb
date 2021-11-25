class Stk < Formula
  desc "Sound Synthesis Toolkit"
  homepage "https://ccrma.stanford.edu/software/stk/"
  url "https://ccrma.stanford.edu/software/stk/release/stk-4.6.2.tar.gz"
  sha256 "573e26ccf72ce436a1dc4ee3bea05fd35e0a8e742c339c7f5b85225502238083"
  license "MIT"

  livecheck do
    url "https://ccrma.stanford.edu/software/stk/download.html"
    regex(/href=.*?stk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stk"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "c36135d90709672488413074814037af4d4a186e183f3689cd9ce209bac59b46"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make"

    lib.install "src/libstk.a"
    bin.install "bin/treesed"

    (include/"stk").install Dir["include/*"]
    doc.install Dir["doc/*"]
    pkgshare.install "src", "projects", "rawwaves"
  end

  def caveats
    <<~EOS
      The header files have been put in a standard search path, it is possible to use an include statement in programs as follows:

        #include \"stk/FileLoop.h\"
        #include \"stk/FileWvOut.h\"

      src/ projects/ and rawwaves/ have all been copied to #{opt_pkgshare}
    EOS
  end

  test do
    assert_equal "xx No input files", shell_output("#{bin}/treesed", 1).chomp
  end
end
