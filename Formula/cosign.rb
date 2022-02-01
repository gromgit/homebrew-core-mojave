class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.5.0",
      revision: "757252063bf4724f11a52336ef13a724059a39b6"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cosign"
    sha256 cellar: :any_skip_relocation, mojave: "d8a16266ff9f59c65f818174b4f96830ae646cfb5adc81954e136c715d8ea6bd"
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
