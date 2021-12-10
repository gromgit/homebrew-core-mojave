class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.41.3.1/metabase.jar"
  sha256 "7fd0d52d38432016990847affcc0c02f8aac16603065edcfc8bde63acf9b1e03"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22e128bc864cba8f9917c6815a5d43fefc5d69580f4f12fcc24b1eae1de782dc"
  end

  head do
    url "https://github.com/metabase/metabase.git"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  # metabase uses jdk.nashorn.api.scripting.JSObject
  # which is removed in Java 15
  depends_on "openjdk@11"

  def install
    if build.head?
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end

    bin.write_jar_script libexec/"metabase.jar", "metabase", java_version: "11"
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
