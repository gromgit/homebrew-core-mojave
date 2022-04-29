class Html2text < Formula
  desc "Advanced HTML-to-text converter"
  homepage "http://www.mbayer.de/html2text/"
  url "https://github.com/grobian/html2text/archive/v2.0.1.tar.gz"
  sha256 "c52f16a282b69b9dc9f7b5fac7f44b15f90b74e012f0aa2d63fbf5b0fe5e5c49"
  license "GPL-2.0"
  head "https://github.com/grobian/html2text.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/html2text"
    sha256 cellar: :any_skip_relocation, mojave: "0352dd9cadce1e7a3ca9a2959dbfff72c47b20a3e22c64a8a093df9f0839b6c6"
  end

  def install
    ENV.cxx11

    system "./configure"
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
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
