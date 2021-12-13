class PkgConfigWrapper < Formula
  desc "Easier way to include C code in your Go program"
  homepage "https://github.com/influxdata/pkg-config"
  url "https://github.com/influxdata/pkg-config/archive/v0.2.9.tar.gz"
  sha256 "25843e58a3e6994bdafffbc0ef0844978a3d1f999915d6770cb73505fcf87e44"
  license "MIT"
  head "https://github.com/influxdata/pkg-config.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pkg-config-wrapper"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "51292c7be979df0eff0b08973ac9224fe2387732fca06c503abf90c1350cddab"
  end

  depends_on "go" => :build
  depends_on "pkg-config"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Found pkg-config executable", shell_output(bin/"pkg-config-wrapper 2>&1", 1)
  end
end
