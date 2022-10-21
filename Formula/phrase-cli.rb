class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.5.2.tar.gz"
  sha256 "4255ea0c647168c61d1b37a0dfec96b585f0bff4fbfc072b8d8d521af7fdd1bf"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/phrase-cli"
    sha256 cellar: :any_skip_relocation, mojave: "c785a76ecd0f0f12885fdb14efc45071dfba2b3b90e9d93f3f989351d6824f89"
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
