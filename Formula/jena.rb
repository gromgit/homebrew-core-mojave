class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-4.6.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-4.6.0.tar.gz"
  sha256 "d5f365e8ef4554bcc1c7853ee04ef6198eb450631244574a37122b3dd71bfda0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "097eefc19c380a9217a6b158ad12ef52eea3cb0e9931660f90228887c81cb949"
  end

  depends_on "openjdk"

  def install
    env = {
      JAVA_HOME: Formula["openjdk"].opt_prefix,
      JENA_HOME: libexec,
    }

    rm_rf "bat" # Remove Windows scripts

    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?

      basename = file.basename
      next if basename.to_s == "service"

      (bin/basename).write_env_script file, env
    end
  end

  test do
    system "#{bin}/sparql", "--version"
  end
end
