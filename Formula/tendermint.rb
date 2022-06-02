class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.35.5.tar.gz"
  sha256 "b82efe466aa23be8b309803533711344fbb31ae05a157bf9df92d886bf230cb7"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tendermint"
    sha256 cellar: :any_skip_relocation, mojave: "cf3127d054df61471ac7ef34bf3a6a202d115a880f10c178612f4d8a7c022986"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "build/tendermint"
  end

  test do
    mkdir(testpath/"staging")
    shell_output("#{bin}/tendermint init full --home #{testpath}/staging")
    assert_predicate testpath/"staging/config/genesis.json", :exist?
    assert_predicate testpath/"staging/config/config.toml", :exist?
    assert_predicate testpath/"staging/data", :exist?
  end
end
