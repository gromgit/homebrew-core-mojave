class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.2.tar.gz"
  sha256 "532fb0751eb7ca9cf855e49e433d63fb760bdf8e131af3440744e792338f706c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rke"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "40a638c3cfd2ef728a4a471bfe0bce0ec7c8aeac482ecd9e1fa19e03a7c010b6"
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
