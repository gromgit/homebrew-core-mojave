class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.46_20210903/wrapper_3.5.46_src.tar.gz"
  sha256 "82e1d0c85488d1389d02e3abe3359a7f759119e356e3e3abd6c6d67615ae5ad8"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/java-service-wrapper"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "7d163c7c94a3a67a943ab6e49bf145d288ef351c651a324157abcf6dd5adda92"
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
