class Skktools < Formula
  desc "SKK dictionary maintenance tools"
  homepage "https://github.com/skk-dev/skktools"
  url "https://deb.debian.org/debian/pool/main/s/skktools/skktools_1.3.4.orig.tar.gz"
  sha256 "84cc5d3344362372e0dfe93a84790a193d93730178401a96248961ef161f2168"
  license "GPL-2.0"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/skktools"
    sha256 cellar: :any, mojave: "393d39193e8135dbbd31efa1793549bab4676dd8c340edbc306735777b6a5cee"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  on_linux do
    depends_on "gdbm"
  end

  def install
    args = ["--with-skkdic-expr2"]
    if OS.linux?
      args << "--with-gdbm"
      # Help find Homebrew's gdbm compatibility layer header
      inreplace %w[configure skkdic-expr.c], "gdbm/ndbm.h", "gdbm-ndbm.h"
    end
    system "./configure", *std_configure_args, *args
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
