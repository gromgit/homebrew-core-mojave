class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.35.2.tar.gz"
  sha256 "2a300b7aa6e4cb09cc77912a923dca490f68fa9c51534bf8c0ec41ea2aa2a5d9"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tendermint"
    sha256 cellar: :any_skip_relocation, mojave: "240215fe3c64736f771fbd3a295759729da16a452b7614c55d3cf7f732b77edb"
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
