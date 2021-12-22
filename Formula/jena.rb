class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-4.3.1.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-4.3.1.tar.gz"
  sha256 "e1dc24cd94fce3d1213efe22db773aaca6a8c1e52e05c02032d6abaa11ba5a09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e47366f5e81b617d0fbb43107dc15b25df2eca8022c10a6ce0dd488413c2d9c"
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
