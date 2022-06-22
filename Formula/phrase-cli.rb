class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/cli"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.4.11.tar.gz"
  sha256 "5d5eeff5df6b44633f6119d0896bae0d79318d79d9bbe6bc80573d112385866e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/phrase-cli"
    sha256 cellar: :any_skip_relocation, mojave: "9dd537e4fb63f39642e7b0eb3830fe019c2de9a551f6f1defb4cf6ee623ed275"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"
  end

  test do
    assert_match "Error: no targets for download specified", shell_output("#{bin}/phrase pull", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
