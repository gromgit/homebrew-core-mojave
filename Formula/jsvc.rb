class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.3.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.3.0-src.tar.gz"
  sha256 "533cd76fe3113d535313c1d8b01ff23caf6babccc699b1a68b4446937cc4474b"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jsvc"
    sha256 cellar: :any_skip_relocation, mojave: "b888d8a127d4addce30af3bf5bd8378d6e8691a7dbf6e7054184321e101258f0"
  end

  depends_on "openjdk"

  def install
    prefix.install %w[NOTICE.txt LICENSE.txt RELEASE-NOTES.txt]

    cd "src/native/unix" do
      system "./configure", "--with-java=#{Formula["openjdk"].opt_prefix}"
      system "make"

      libexec.install "jsvc"
      (bin/"jsvc").write_env_script libexec/"jsvc", Language::Java.overridable_java_home_env
    end
  end

  test do
    output = shell_output("#{bin}/jsvc -help")
    assert_match "jsvc (Apache Commons Daemon)", output
  end
end
