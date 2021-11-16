class Blazegraph < Formula
  desc "Graph database supporting RDF data model, Sesame, and Blueprint APIs"
  homepage "https://www.blazegraph.com/"
  url "https://github.com/blazegraph/database/releases/download/BLAZEGRAPH_RELEASE_2_1_5/blazegraph.jar"
  version "2.1.5"
  sha256 "fbaeae7e1b3af71f57cfc4da58b9c52a9ae40502d431c76bafa5d5570d737610"

  livecheck do
    url :stable
    regex(/^BLAZEGRAPH(?:_RELEASE)?[._-]v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e84fba2f0906deaa65d7eea65893f4465238b482a71c4fc41f785c6f18fc27fe"
  end

  # Dependencies can be lifted in the upcoming release, > 2.1.5
  depends_on arch: :x86_64 # openjdk@8 doesn't support ARM
  depends_on "openjdk@8"

  def install
    libexec.install "blazegraph.jar"
    bin.write_jar_script libexec/"blazegraph.jar", "blazegraph", java_version: "1.8"
  end

  plist_options startup: "true"

  service do
    run opt_bin/"blazegraph"
    working_dir opt_prefix
  end

  test do
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    server = fork do
      exec bin/"blazegraph"
    end
    sleep 5
    Process.kill("TERM", server)
    assert_predicate testpath/"blazegraph.jnl", :exist?
    assert_predicate testpath/"rules.log", :exist?
  end
end
