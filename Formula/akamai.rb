class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "ffd4954782a3e524b91d743a6f65f7b8514872a2c059009af638571ec7a89fe7"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/akamai"
    sha256 cellar: :any_skip_relocation, mojave: "8efb2b8c0745c5bd8b7e6982da0c71834260c5aae22a4d239018d7405f52ef88"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "Purge", pipe_output("#{bin}/akamai install --force purge", "n")
  end
end
