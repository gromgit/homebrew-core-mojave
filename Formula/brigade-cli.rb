class BrigadeCli < Formula
  desc "Brigade command-line interface"
  homepage "https://brigade.sh"
  url "https://github.com/brigadecore/brigade.git",
      tag:      "v2.1.0",
      revision: "92a824cff34255774e246be64693230db555efe1"
  license "Apache-2.0"
  head "https://github.com/brigadecore/brigade.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/brigade-cli"
    sha256 cellar: :any_skip_relocation, mojave: "0ada9665139ce22750aeb8d9221f9dfb7ff4019306591d3786cfb190ce06992d"
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
