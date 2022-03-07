class Html2text < Formula
  desc "Advanced HTML-to-text converter"
  homepage "http://www.mbayer.de/html2text/"
  url "https://github.com/grobian/html2text/archive/v2.0.0.tar.gz"
  sha256 "061125bfac658c6d89fa55e9519d90c5eeb3ba97b2105748ee62f3a3fa2449de"
  license "GPL-2.0"
  head "https://github.com/grobian/html2text.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/html2text"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "fc6087002a9f275a9195e6c93ba2d2331a58a5e15fddf4f77e8d3d8cc20ba7bc"
  end

  def install
    ENV.cxx11

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "all"

    bin.install "html2text"
    man1.install "html2text.1"
    man5.install "html2textrc.5"
  end

  test do
    path = testpath/"index.html"
    path.write <<~EOS
      <!DOCTYPE html>
      <html>
        <head><title>Home</title></head>
        <body><p>Hello World</p></body>
      </html>
    EOS

    output = `#{bin}/html2text #{path}`.strip
    assert_equal "Hello World", output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
