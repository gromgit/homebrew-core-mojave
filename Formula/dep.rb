class Dep < Formula
  desc "Go dependency management tool"
  homepage "https://github.com/golang/dep"
  url "https://github.com/golang/dep.git",
      tag:      "v0.5.4",
      revision: "1f7c19e5f52f49ffb9f956f64c010be14683468b"
  license "BSD-3-Clause"
  head "https://github.com/golang/dep.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dep"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "2632fa4733896d47567103f5f4d8ca69bfed918860d4e181dd2068f73a50ddd0"
  end


  deprecate! date: "2020-11-25", because: :repo_archived

  depends_on "go"

  conflicts_with "deployer", because: "both install `dep` binaries"

  # Allow building on Apple ARM
  patch :DATA

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    platform = OS.kernel_name.downcase

    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/golang/dep").install buildpath.children
    cd "src/github.com/golang/dep" do
      ENV["DEP_BUILD_PLATFORMS"] = platform
      ENV["DEP_BUILD_ARCHS"] = arch
      system "hack/build-all.bash"
      bin.install "release/dep-#{platform}-#{arch}" => "dep"
      prefix.install_metafiles
    end
  end

  test do
    # Default HOMEBREW_TEMP is /tmp, which is actually a symlink to /private/tmp.
    # `dep` bails without `.realpath` as it expects $GOPATH to be a "real" path.
    ENV["GOPATH"] = testpath.realpath
    project = testpath/"src/github.com/project/testing"
    (project/"hello.go").write <<~EOS
      package main

      import "fmt"
      import "github.com/Masterminds/vcs"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    cd project do
      system bin/"dep", "init"
      assert_predicate project/"vendor", :exist?, "Failed to init!"
      inreplace "Gopkg.toml", /(version = ).*/, "\\1\"=1.11.0\""
      system bin/"dep", "ensure"
      assert_match "795e20f90", (project/"Gopkg.lock").read
      output = shell_output("#{bin}/dep status")
      assert_match %r{github.com/Masterminds/vcs\s+1.11.0\s}, output
    end
  end
end

__END__
diff --git a/hack/build-all.bash b/hack/build-all.bash
index 58d5bc2d..0c574a45 100755
--- a/hack/build-all.bash
+++ b/hack/build-all.bash
@@ -50,7 +50,7 @@ for OS in ${DEP_BUILD_PLATFORMS[@]}; do
     else
       CGO_ENABLED=0
     fi
-    if [[ "${ARCH}" == "ppc64" || "${ARCH}" == "ppc64le" || "${ARCH}" == "s390x" || "${ARCH}" == "arm" || "${ARCH}" == "arm64" ]] && [[ "${OS}" != "linux" ]]; then
+    if [[ "${ARCH}" == "ppc64" || "${ARCH}" == "ppc64le" || "${ARCH}" == "s390x" || "${ARCH}" == "arm" ]] && [[ "${OS}" != "linux" ]]; then
         # ppc64, ppc64le, s390x, arm and arm64 are only supported on Linux.
         echo "Building for ${OS}/${ARCH} not supported."
     else
