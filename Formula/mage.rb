class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.12.1",
      revision: "2f1ec406dfa856a4b8378ef837061abc2a0ce01b"
  license "Apache-2.0"
  head "https://github.com/magefile/mage.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mage"
    sha256 cellar: :any_skip_relocation, mojave: "d2da91d98adad62480fb9efd3f311f0d56a5406772d3f5c0ac3af7cd5da0fd96"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/magefile/mage/mage.timestamp=#{time.rfc3339}
      -X github.com/magefile/mage/mage.commitHash=#{Utils.git_short_head}
      -X github.com/magefile/mage/mage.gitTag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "magefile.go created", shell_output("#{bin}/mage -init 2>&1")
    assert_predicate testpath/"magefile.go", :exist?
  end
end
