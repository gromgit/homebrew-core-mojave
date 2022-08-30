class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.5.8.tar.gz"
  sha256 "1abfce59d1676d858672bf8f3924e2f9ace826411bad95d8171aa5e67b7f9f35"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ld-find-code-refs"
    sha256 cellar: :any_skip_relocation, mojave: "d05d450da91c99f788d5028703b0fa6b5ecd70f115bf63f5d8f96dcfd60464d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ld-find-code-refs"
  end

  test do
    system "git", "init"
    (testpath/"README").write "Testing"
    (testpath/".gitignore").write "Library"
    system "git", "add", "README", ".gitignore"
    system "git", "commit", "-m", "Initial commit"

    assert_match "git branch: master",
      shell_output(bin/"ld-find-code-refs --dryRun --ignoreServiceErrors -t=xx -p=test -r=test -d=.")
  end
end
