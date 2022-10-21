class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v2.0.13.tar.gz"
  sha256 "3f8c754e2ad72fcf7690242ab04d258781c6918b9283c2f1e88b16665802d950"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/railway"
    sha256 cellar: :any_skip_relocation, mojave: "dd920e81026a98a7fc5e346183c143d5157829915950103214ea090b83dfaf4b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/railwayapp/cli/constants.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Account required to init project", output
  end
end
