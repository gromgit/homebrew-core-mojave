class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.0.3.tar.gz"
  sha256 "68e14e188096d5303d87bc673782e9143ae925c635787076790b1607447e3645"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mongodb-atlas-cli"
    sha256 cellar: :any_skip_relocation, mojave: "bc1a341d65347e326fb50fb0f836cf8e1db0e5585d223bd548ac51969caf09aa"
  end

  depends_on "go" => :build

  def install
    with_env(
      ATLAS_VERSION: version.to_s,
      MCLI_GIT_SHA:  "homebrew-release",
    ) do
      system "make", "build-atlascli"
    end
    bin.install "bin/atlas"

    (bash_completion/"atlas").write Utils.safe_popen_read(bin/"atlas", "completion", "bash")
    (fish_completion/"atlas.fish").write Utils.safe_popen_read(bin/"atlas", "completion", "fish")
    (zsh_completion/"_atlas").write Utils.safe_popen_read(bin/"atlas", "completion", "zsh")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
