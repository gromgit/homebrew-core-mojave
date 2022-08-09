class Flume < Formula
  desc "Hadoop-based distributed log collection and aggregation"
  homepage "https://flume.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=flume/1.10.0/apache-flume-1.10.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/flume/1.10.0/apache-flume-1.10.0-bin.tar.gz"
  sha256 "c9d09cb473ede45be6d478b33b1cc3289e871c150e035246fb594bc3e81b3381"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ed56b1cc2920649c2942b963e5f0b77ad852679b3e1177b3438d8fdef86cd00f"
  end

  depends_on "hadoop"
  depends_on "openjdk@11"

  def install
    rm_f Dir["bin/*.cmd", "bin/*.ps1"]
    libexec.install %w[conf docs lib tools]
    prefix.install "bin"

    flume_env = Language::Java.java_home_env("11")
    flume_env[:FLUME_HOME] = libexec
    bin.env_script_all_files libexec/"bin", flume_env
  end

  test do
    assert_match "Flume #{version}", shell_output("#{bin}/flume-ng version")
  end
end
