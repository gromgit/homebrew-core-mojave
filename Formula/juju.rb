class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.33",
      revision: "95186b2e0c2dfa9fe7b0b815cfe2c939813f9302"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/juju"
    sha256 cellar: :any_skip_relocation, mojave: "d0153221d05c3b055806350b27ea05c06f92c2acdb3a7fade5bbe1ab86e32fb9"
  end

  depends_on "go" => :build

  def install
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{Utils.git_head}
      -X version.GitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ld_flags), "./cmd/juju"
    system "go", "build", *std_go_args(output: bin/"juju-metadata", ldflags: ld_flags), "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
