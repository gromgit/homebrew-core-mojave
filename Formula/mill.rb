class Mill < Formula
  desc "Scala build tool"
  homepage "https://com-lihaoyi.github.io/mill/mill/Intro_to_Mill.html"
  url "https://github.com/com-lihaoyi/mill/releases/download/0.10.9/0.10.9-assembly"
  sha256 "5c3cb4edd173ca5465f36e5062a46de5ec9d54f4788c47af0b656bab181316dd"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1aee1561529d46dc64504ebe5bc76077eae5d1205fc9efafd5ebb7e4af862a27"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"].shift => "mill"
    chmod 0555, libexec/"mill"
    (bin/"mill").write_env_script libexec/"mill", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"build.sc").write <<~EOS
      import mill._
      import mill.scalalib._
      object foo extends ScalaModule {
        def scalaVersion = "2.12.8"
      }
    EOS
    output = shell_output("#{bin}/mill resolve __.compile")
    assert_equal "foo.compile", output.lines.last.chomp
  end
end
