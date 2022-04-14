class Ringojs < Formula
  desc "CommonJS-based JavaScript runtime"
  homepage "https://ringojs.org"
  url "https://github.com/ringo/ringojs/releases/download/v3.0.0/ringojs-3.0.0.tar.gz"
  sha256 "7f37388f5c0f05deec29c429151478a3758510566707bc0baf91f865126ca526"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ringojs"
    sha256 cellar: :any_skip_relocation, mojave: "6b31c53a9b6168901c52dddfccb9671150401e2a2873f7708c6fce35605bf1e0"
  end

  depends_on "openjdk@11"

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    env = { RINGO_HOME: libexec }
    env.merge! Language::Java.overridable_java_home_env("11")
    bin.env_script_all_files libexec/"bin", env
  end

  test do
    (testpath/"test.js").write <<~EOS
      var x = 40 + 2;
      console.assert(x === 42);
    EOS
    system "#{bin}/ringo", "test.js"
  end
end
