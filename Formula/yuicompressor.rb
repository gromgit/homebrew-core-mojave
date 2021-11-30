class Yuicompressor < Formula
  desc "Yahoo! JavaScript and CSS compressor"
  homepage "https://yui.github.io/yuicompressor/"
  url "https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.zip"
  sha256 "3243fd79cb68cc61a5278a8ff67a0ad6a2d825c36464594b66900ad8426a6a6e"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "94b45d04e09ea0fda70a1913d9af1c1770ff333c1602e67f1d2c2b9fa4f1fecd"
  end

  depends_on "openjdk"

  def install
    libexec.install "yuicompressor-#{version}.jar"
    bin.write_jar_script libexec/"yuicompressor-#{version}.jar", "yuicompressor"
  end

  test do
    path = testpath/"test.js"
    path.write <<~EOS
      var i = 1;      // foo
      console.log(i); // bar
    EOS

    output = `#{bin}/yuicompressor --nomunge --preserve-semi #{path}`.strip
    assert_equal "var i=1;console.log(i);", output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
