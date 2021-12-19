class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.47_20211207/wrapper_3.5.47_src.tar.gz"
  sha256 "1a171c7d81bcaf8ef1954c284668e51f5123d60559f381f19469163aa37e1651"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/java-service-wrapper"
    sha256 cellar: :any_skip_relocation, mojave: "17d566c0aa1c946cb31743e9472ef9a938610c1fc45e9bd936bb0175581ef4ab"
  end

  depends_on "ant" => :build
  depends_on "openjdk@11" => :build
  on_linux do
    depends_on "cunit" => :build
  end

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    # Default javac target version is 1.4, use 1.6 which is the minimum available on openjdk@11
    system "ant", "-Dbits=64", "-Djavac.target.version=1.6"
    libexec.install "lib", "bin", "src/bin" => "scripts"
  end

  test do
    output = shell_output("#{libexec}/bin/testwrapper status", 1)
    assert_match("Test Wrapper Sample Application", output)
  end
end
