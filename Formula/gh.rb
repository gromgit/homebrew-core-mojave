class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.17.0.tar.gz"
  sha256 "0e8db6dbb148a899db45f4dc8165644f6361d9bd6d088aa7633368b3baedbe54"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gh"
    sha256 cellar: :any_skip_relocation, mojave: "604367a56df85e300591ff630e31a2863c01117a3aca0ef5b841325abddf61a4"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
