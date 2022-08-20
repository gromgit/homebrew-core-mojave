class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.44.1/metabase.jar"
  sha256 "4c842b9b374b0ffa7031b7757722e1dddd9b6aebbb5afe82d82b6eb9730d3791"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f5d6f52133af818a89d316ff79aa904077f0880234731b7ddd90b81f92964b1"
  end

  head do
    url "https://github.com/metabase/metabase.git"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end

    bin.write_jar_script libexec/"metabase.jar", "metabase"
  end

  plist_options startup: true
  service do
    run opt_bin/"metabase"
    keep_alive true
    working_dir var/"metabase"
    log_path var/"metabase/server.log"
    error_log_path "/dev/null"
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end
