class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.49_20220209/wrapper_3.5.49_src.tar.gz"
  sha256 "81c49c1792c8a96541bfc7ab237846e6db790593ced979611400b3d58eb4fafe"
  license "GPL-2.0-only"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/java-service-wrapper"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "225298a219bdaaf4d853c1152c657e84850bf4187d7bd9758a139d33f036bd23"
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
    if OS.mac?
      if Hardware::CPU.arm?
        ln_s "libwrapper.dylib", libexec/"lib/libwrapper.jnilib"
      else
        ln_s "libwrapper.jnilib", libexec/"lib/libwrapper.dylib"
      end
    end
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    output = shell_output("#{libexec}/bin/testwrapper status", 1)
    assert_match("Test Wrapper Sample Application", output)
  end
end
