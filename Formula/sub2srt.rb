require "language/perl"

class Sub2srt < Formula
  include Language::Perl::Shebang

  desc "Convert subtitles from .sub to subviewer .srt format"
  homepage "https://github.com/robelix/sub2srt"
  url "https://github.com/robelix/sub2srt/archive/0.5.5.tar.gz"
  sha256 "169d94d1d0e946a5d57573b7b7b5883875996f802362341fe1a1a0220229b905"
  license "GPL-2.0-or-later"
  head "https://github.com/robelix/sub2srt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b13ea475d840e7fbe89a3c035e7552debd0e355abc8bfce97d476b8d912e2137"
  end

  uses_from_macos "perl"

  def install
    inreplace "README", "/usr/local", HOMEBREW_PREFIX
    rewrite_shebang detected_perl_shebang, "sub2srt"
    bin.install "sub2srt"
  end

  test do
    (testpath/"test.sub").write <<~EOS
      {1100}{1300}time to...|one
      {1350}{1400}homebrew|two
    EOS
    expected = <<~EOS
      1
      00:00:44,000 --> 00:00:52,000
      time to...
      one

      2
      00:00:54,000 --> 00:00:56,000
      homebrew
      two
    EOS
    system "#{bin}/sub2srt", "#{testpath}/test.sub"
    assert_equal expected, (testpath/"test.srt").read.chomp
  end
end
