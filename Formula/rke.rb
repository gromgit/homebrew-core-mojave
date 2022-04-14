class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.8.tar.gz"
  sha256 "4087a7e04a106dac40db3a84a61eed757e87ccac8dc792aeab4c328576099013"
  license "Apache-2.0"

  # It's necessary to check releases instead of tags here (to avoid upstream
  # tag issues) but we can't use the `GithubLatest` strategy because upstream
  # creates releases for more than one minor version (i.e., the "latest" release
  # isn't the newest version at times). We normally avoid checking the releases
  # page because pagination can cause problems but this is our only choice.
  livecheck do
    url "https://github.com/rancher/rke/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rke"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "e70e390386d14946b77edce667d36a140c449c489c4af53419f0f13d4c2339a4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-w -X main.VERSION=v#{version}",
            "-o", bin/"rke"
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
