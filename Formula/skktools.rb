class Skktools < Formula
  desc "SKK dictionary maintenance tools"
  homepage "https://github.com/skk-dev/skktools"
  url "https://deb.debian.org/debian/pool/main/s/skktools/skktools_1.3.4.orig.tar.gz"
  sha256 "84cc5d3344362372e0dfe93a84790a193d93730178401a96248961ef161f2168"
  license "GPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "2516509661552b0b851aadc8da1e3ecf821a5527dd6ab8d0d268ad5dfdc14b33"
    sha256 cellar: :any, arm64_big_sur:  "4a56dad3435d1507d1fa2a087f4294d9955eb30993a70955c75e972a5c4ddb6b"
    sha256 cellar: :any, monterey:       "4054365c06a67f80e59461c48492c922ac1810580fcb366ed87b603b07b2b4d2"
    sha256 cellar: :any, big_sur:        "3a36d3ceab583dd2518b5dde10b8d443fbaf30e1de0d867f095effa5982fa1f3"
    sha256 cellar: :any, catalina:       "c10f7baf6bc379ed47fc82b5bf1dd2ae8cbc53c358f5c838e87d8440ae8c5ebd"
    sha256 cellar: :any, mojave:         "e3e3033a8f0d05939c9ebe2ab73cff7377351a36b8276337c920026c27d0a127"
    sha256 cellar: :any, high_sierra:    "65826868e8d1ca3d310ebc14e2aadc281b09751220e3310643b4e2aa4ab9ee68"
    sha256 cellar: :any, sierra:         "b190a2b730f1604ac76725e99c5fd9927ed5a7cbba905291f017b77fee1e3c85"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-skkdic-expr2"

    system "make", "CC=#{ENV.cc}"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    test_dic = <<~EOS.strip.tap { |s| s.encode("euc-jis-2004") }
      わるs /悪/
      わるk /悪/
      わるi /悪/
    EOS
    (testpath/"SKK-JISYO.TEST").write test_dic

    test_shuffle = <<~EOS.tap { |s| s.encode("euc-jis-2004") }
      わるs /悪/
      わるi /悪/
      わるk /悪/
    EOS

    expect_shuffle = <<~EOS.tap { |s| s.encode("euc-jis-2004") }
      ;; okuri-ari entries.
      わるs /悪/
      わるk /悪/
      わるi /悪/
    EOS

    test_sp1 = <<~EOS.strip.tap { |s| s.encode("euc-jis-2004") }
      わるs /悪/
      わるk /悪/
    EOS
    (testpath/"test.sp1").write test_sp1

    test_sp2 = <<~EOS.strip.tap { |s| s.encode("euc-jis-2004") }
      わるk /悪/
      わるi /悪/
    EOS
    (testpath/"test.sp2").write test_sp2

    test_sp3 = <<~EOS.strip.tap { |s| s.encode("euc-jis-2004") }
      わるi /悪/
    EOS
    (testpath/"test.sp3").write test_sp3

    expect_expr = <<~EOS.tap { |s| s.encode("euc-jis-2004") }
      ;; okuri-ari entries.
      わるs /悪/
      わるk /悪/
    EOS

    expect_count = "SKK-JISYO.TEST: 3 candidates\n"
    actual_count = shell_output("#{bin}/skkdic-count SKK-JISYO.TEST")
    assert_equal expect_count, actual_count

    actual_shuffle = pipe_output("#{bin}/skkdic-sort", test_shuffle, 0)
    assert_equal expect_shuffle, actual_shuffle

    ["skkdic-expr", "skkdic-expr2"].each do |cmd|
      expr_cmd = "#{bin}/#{cmd} test.sp1 + test.sp2 - test.sp3"
      actual_expr = shell_output(expr_cmd)
      assert_equal expect_expr, pipe_output("#{bin}/skkdic-sort", actual_expr)
    end
  end
end
