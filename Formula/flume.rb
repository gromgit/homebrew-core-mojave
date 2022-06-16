class Flume < Formula
  desc "Hadoop-based distributed log collection and aggregation"
  homepage "https://flume.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=flume/1.10.0/apache-flume-1.10.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/flume/1.10.0/apache-flume-1.10.0-bin.tar.gz"
  sha256 "c9d09cb473ede45be6d478b33b1cc3289e871c150e035246fb594bc3e81b3381"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb04c708d2c0e6590e7cd6a504df26c480719eb70d5744108b7bf660bb90442a"
  end

  depends_on "hadoop"
  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.cmd", "bin/*.ps1"]
    libexec.install %w[conf docs lib tools]
    bin.install Dir["bin/*"]
    bin.env_script_all_files libexec/"bin",
                             JAVA_HOME:  Formula["openjdk"].opt_prefix,
                             FLUME_HOME: libexec
  end

  test do
    assert_match "Flume #{version}", shell_output("#{bin}/flume-ng version")
  end
end
