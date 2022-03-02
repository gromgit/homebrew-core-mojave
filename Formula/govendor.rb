class Govendor < Formula
  desc "Tool for vendoring Go dependencies"
  homepage "https://github.com/kardianos/govendor"
  url "https://github.com/kardianos/govendor/archive/v1.0.9.tar.gz"
  sha256 "d303abf194838792234a1451c3a1e87885d1b2cd21774867b592c1f7db00551e"
  license "BSD-3-Clause"
  head "https://github.com/kardianos/govendor.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/govendor"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "9d2979020a78715012fea942a3b03f1063c9da1e73614368c4fd6921f0e977ea"
  end


  deprecate! date: "2020-03-02", because: :repo_archived

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/kardianos/").mkpath
    ln_sf buildpath, buildpath/"src/github.com/kardianos/govendor"
    system "go", "build", *std_go_args
  end

  test do
    # Default HOMEBREW_TEMP is /tmp, which is actually a symlink to /private/tmp.
    # `govendor` bails without `.realpath` as it expects $GOPATH to be "real" path.
    ENV["GOPATH"] = testpath.realpath
    commit = "89d9e62992539701a49a19c52ebb33e84cbbe80f"
    (testpath/"src/github.com/project/testing").mkpath

    cd "src/github.com/project/testing" do
      system bin/"govendor", "init"
      assert_predicate Pathname.pwd/"vendor", :exist?, "Failed to init!"
      system bin/"govendor", "fetch", "-tree", "golang.org/x/crypto@#{commit}"
      assert_match commit, File.read("vendor/vendor.json")
      assert_match "golang.org/x/crypto/blowfish", shell_output("#{bin}/govendor list")
    end
  end
end
