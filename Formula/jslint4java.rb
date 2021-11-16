class Jslint4java < Formula
  desc "Java wrapper for JavaScript Lint (jsl)"
  homepage "https://code.google.com/archive/p/jslint4java/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/jslint4java/jslint4java-2.0.5-dist.zip"
  sha256 "078240b17256a0472f9981d68f11556238658ebaa67be49ea49958adafc96a81"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "42851a1611e21e6ea7b35510783b3165bd2f34606345931bd781ab993f3b0c38"
  end

  depends_on "openjdk"

  def install
    doc.install Dir["docs/*"]
    libexec.install Dir["*.jar"]
    bin.write_jar_script Dir[libexec/"jslint4java*.jar"].first, "jslint4java"
  end

  test do
    path = testpath/"test.js"
    path.write <<~EOS
      var i = 0;
      var j = 1  // no semicolon
    EOS
    output = shell_output("#{bin}/jslint4java #{path}", 1)
    assert_match "2:10:Expected ';' and instead saw '(end)'", output
  end
end
