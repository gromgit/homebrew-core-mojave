class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/v7.8.0.tar.gz"
  sha256 "a5c04923307ffe8e6cf6ec3ea720170e1565078af5eebba743556db855da8d03"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-town"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "756977d902a41322c3ab5a196dc1651d93e035985b2062129ee1f7c4ae0e932d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v7/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v7/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town version")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
