class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v3.0.6.tar.gz"
  sha256 "21c110ed673be47b81c8bf311a8715168e7080cb714ac78e3a4cd51ef596b8ac"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "463b3b0c6d655013d78deadb400010e073c3940e5810d32676a329d330006a69"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    system "sbt", "-sbt-jar", Formula["sbt"].opt_libexec/"bin/sbt-launch.jar", "core/assembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec/"wartremover-assembly.jar", "wartremover"
  end

  test do
    (testpath/"foo").write <<~EOS
      object Foo {
        def foo() {
          var msg = "Hello World"
          println(msg)
        }
      }
    EOS
    cmd = "#{bin}/wartremover -traverser org.wartremover.warts.Unsafe foo 2>&1"
    assert_match "var is disabled", shell_output(cmd, 1)
  end
end
