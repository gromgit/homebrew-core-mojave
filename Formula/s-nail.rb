class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.24.tar.xz"
  sha256 "2714d6b8fb2af3b363fc7c79b76d058753716345d1b6ebcd8870ecd0e4f7ef8c"
  license all_of: [
    "BSD-2-Clause", # file-dotlock.h
    "BSD-3-Clause",
    "BSD-4-Clause",
    "ISC",
    "HPND-sell-variant", # GSSAPI code
    "RSA-MD", # MD5 code
  ]

  livecheck do
    url :homepage
    regex(/href=.*?s-nail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/s-nail"
    rebuild 2
    sha256 mojave: "cfbf997ca81a95d03c38844b8d338b8fae985e05367ae34e629812a1e9134f4b"
  end

  depends_on "awk" => :build
  depends_on "libidn"
  depends_on "openssl@1.1"

  def install
    system "make", "CC=#{ENV.cc}",
                   "C_INCLUDE_PATH=#{Formula["openssl@1.1"].opt_include}",
                   "LDFLAGS=-L#{Formula["openssl@1.1"].opt_lib}",
                   "VAL_PREFIX=#{prefix}",
                   "OPT_DOTLOCK=no",
                   "config"
    system "make", "build"
    system "make", "install"
  end

  test do
    timestamp = 844_221_007
    ENV["SOURCE_DATE_EPOCH"] = timestamp.to_s

    date1 = Time.at(timestamp).strftime("%a %b %e %T %Y")
    date2 = Time.at(timestamp).strftime("%a, %d %b %Y %T %z")

    expected = <<~EOS
      From reproducible_build #{date1.chomp}
      Date: #{date2.chomp}
      User-Agent: s-nail reproducible_build

      Hello oh you Hammer2!
    EOS

    input = "Hello oh you Hammer2!\n"
    output = pipe_output("#{bin}/s-nail -#:/ -Sexpandaddr -", input, 0)
    assert_equal expected, output.chomp
  end
end
