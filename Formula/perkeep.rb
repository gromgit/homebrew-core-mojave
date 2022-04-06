class Perkeep < Formula
  desc "Lets you permanently keep your stuff, for life"
  homepage "https://perkeep.org/"
  license "Apache-2.0"
  revision 1
  head "https://github.com/perkeep/perkeep.git", branch: "master"

  stable do
    url "https://github.com/perkeep/perkeep.git",
        tag:      "0.11",
        revision: "76755286451a1b08e2356f549574be3eea0185e5"

    # Newer gopherjs to support a newer Go version.
    resource "gopherjs" do
      url "https://github.com/gopherjs/gopherjs/archive/refs/tags/1.17.1+go1.17.3.tar.gz"
      sha256 "8c5275ddf09646fdeb9df701f49425feb2327ec25dddfa49e2d9d323813398af"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/perkeep"
    sha256 cellar: :any_skip_relocation, mojave: "7b80c0a2c2d3ef585f85afb9f56bf82ecab63514c2b37f651692c511cf78cb45"
  end

  # This should match what gopherjs supports.
  depends_on "go@1.17" => :build
  depends_on "pkg-config" => :build

  conflicts_with "hello", because: "both install `hello` binaries"

  def install
    if build.stable?
      ENV["GOPATH"] = buildpath
      ENV["CAMLI_GOPHERJS_GOROOT"] = Formula["go"].opt_libexec

      (buildpath/"src/perkeep.org").install buildpath.children

      # Vendored version of gopherjs requires go 1.10, so use the newest available gopherjs, which
      # supports newer Go versions.
      rm_rf buildpath/"src/perkeep.org/vendor/github.com/gopherjs/gopherjs"
      resource("gopherjs").stage buildpath/"src/perkeep.org/vendor/github.com/gopherjs/gopherjs"

      cd "src/perkeep.org" do
        system "go", "run", "make.go"
      end

      bin.install Dir["bin/*"].select { |f| File.executable? f }
    else
      system "go", "run", "make.go"
      bin.install Dir[".brew_home/go/bin/*"].select { |f| File.executable? f }
    end
  end

  service do
    run [opt_bin/"perkeepd", "-openbrowser=false"]
    keep_alive true
  end

  test do
    system bin/"pk-get", "-version"
  end
end
