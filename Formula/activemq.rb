class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/5.17.0/apache-activemq-5.17.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/5.17.0/apache-activemq-5.17.0-bin.tar.gz"
  sha256 "eb06abd7f45efad42f4f56b671fee7dff4ccac387e0765b1d256e19bea66f897"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/activemq"
    sha256 cellar: :any_skip_relocation, mojave: "719ec3204d9afe70a90a874563dc55e8f01c5f6f1ad5051dc8d66e6a7847712f"
  end

  depends_on "java-service-wrapper"
  depends_on "openjdk"

  def install
    useless = OS.mac? ? "linux" : "{macosx,linux-x86-32}"
    buildpath.glob("bin/#{useless}*").map(&:rmtree)

    libexec.install buildpath.children
    wrapper_dir = OS.mac? ? "macosx" : "#{OS.kernel_name.downcase}-#{Hardware::CPU.arch}".tr("_", "-")
    libexec.glob("bin/#{wrapper_dir}/{wrapper,libwrapper.{so,jnilib}}").map(&:unlink)
    (bin/"activemq").write_env_script libexec/"bin/activemq", Language::Java.overridable_java_home_env

    wrapper = Formula["java-service-wrapper"].opt_libexec
    wrapper_dir = libexec/"bin"/wrapper_dir
    ln_sf wrapper/"bin/wrapper", wrapper_dir/"wrapper"
    libext = OS.mac? ? "jnilib" : "so"
    ln_sf wrapper/"lib/libwrapper.#{libext}", wrapper_dir/"libwrapper.#{libext}"
    ln_sf wrapper/"lib/wrapper.jar", wrapper_dir/"wrapper.jar"
  end

  service do
    run [opt_bin/"activemq", "console"]
    working_dir opt_libexec
  end

  test do
    system "#{bin}/activemq", "browse", "-h"
  end
end
