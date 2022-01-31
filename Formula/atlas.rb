class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.3.2.tar.gz"
  sha256 "c295db029aaa11e6ae2b2db477c90674e1261f4680f75e97b90525385a33bfbb"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/atlas"
    sha256 cellar: :any_skip_relocation, mojave: "124993401b9d339df2e3a42e57d1c99c2eaf641d7b82b56168cf8ee958632b0e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/action.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/atlas"
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -d \"mysql://user:pass@tcp(localhost:3306)/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
