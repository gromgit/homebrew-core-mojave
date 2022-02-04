class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.6.tar.gz"
  sha256 "74590d52a9eefd12a473cd91515187ca9919918c0cd2c2b6b7260c7faa53ba86"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rke"
    sha256 cellar: :any_skip_relocation, mojave: "857635c761228eda014d1768fa103f1ef70c81e27e5df23860b3076d3fec8055"
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
