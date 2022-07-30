class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "e7af6f7206e58dfaf4336169298a481de71c2e2b1dea457c17a241632ce2d9b6"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/manifest-tool"
    sha256 cellar: :any_skip_relocation, mojave: "516efacc5594d3a3b5a6d6c07f57e00b87fea9b7b682da45ff5a0f554c936db3"
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    package = "busybox:latest"
    stdout, stderr, = Open3.capture3(
      bin/"manifest-tool", "inspect",
      package
    )

    if stderr.lines.grep(/429 Too Many Requests/).first
      print "Can't test against docker hub\n"
      print stderr.lines.join("\n")
    else
      assert_match package, stdout.lines.grep(/^Name:/).first
      assert_match "sha", stdout.lines.grep(/Digest:/).first
      assert_match "Platform:", stdout.lines.grep(/Platform:/).first
      assert_match "OS:", stdout.lines.grep(/OS:\s*linux/).first
      assert_match "Arch:", stdout.lines.grep(/Arch:\s*amd64/).first
    end

    assert_match version.to_s, shell_output("#{bin}/manifest-tool --version")
  end
end
