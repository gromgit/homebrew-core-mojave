class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.5.2",
      revision: "8ffcd1228c463e1ad26ccce68ae16deeca2960b4"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cosign"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "135ec8ca7c64dbb627ac1a60171c5e563bde8e736476bce2c758ac7f0eb322c6"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/sigstore/cosign/pkg/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.GitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState="clean"
      -X #{pkg}.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cosign"
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath/"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin/"cosign version")
  end
end
