class BrigadeCli < Formula
  desc "Brigade command-line interface"
  homepage "https://brigade.sh"
  url "https://github.com/brigadecore/brigade.git",
      tag:      "v2.5.0",
      revision: "838e8fd2357e3ace0b2080544a9faf3229be8b3d"
  license "Apache-2.0"
  head "https://github.com/brigadecore/brigade.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/brigade-cli"
    sha256 cellar: :any_skip_relocation, mojave: "35c31aec7a81f9ee8537983eb295acd5ae57995d7bb9cdd562919c620875dc9c"
  end

  depends_on "go" => :build

  def install
    ENV["SKIP_DOCKER"] = "true"
    ENV["VERSION"] = "v#{version}"

    system "make", "hack-build-cli"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip
    bin.install "bin/brig-#{os}-#{arch}" => "brig"
  end

  test do
    system bin/"brig", "init", "--id", "foo"
    assert_predicate testpath/".brigade", :directory?

    version_output = shell_output(bin/"brig version 2>&1")
    assert_match "Brigade client:", version_output

    return unless build.stable?

    commit = stable.specs[:revision][0..6]
    assert_match "Brigade client: version v#{version} -- commit #{commit}", version_output
  end
end
