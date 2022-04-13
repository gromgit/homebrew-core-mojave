class JvmMon < Formula
  desc "Console-based JVM monitoring"
  homepage "https://github.com/ajermakovics/jvm-mon"
  url "https://github.com/ajermakovics/jvm-mon/releases/download/0.3/jvm-mon-0.3.tar.gz"
  sha256 "9b5dd3d280cb52b6e2a9a491451da2ee41c65c770002adadb61b02aa6690c940"
  license "Apache-2.0"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jvm-mon"
    sha256 cellar: :any_skip_relocation, mojave: "c20d541a04a08a0282c90ed1968fbc03d5be5012f9a73e22b52d2ded67c9a880"
  end

  depends_on "openjdk@8"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]

    (bin/"jvm-mon").write_env_script libexec/"bin/jvm-mon", Language::Java.java_home_env("1.8")
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Duser.home=#{testpath}"
    system "echo q | #{bin}/jvm-mon"
  end
end
