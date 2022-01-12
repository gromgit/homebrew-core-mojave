class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.4.tar.gz"
  sha256 "97d56fb2e0e8b221c36ab66559a84bd2a9af11f9b8d69c959bd9c9b9e57311af"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rke"
    sha256 cellar: :any_skip_relocation, mojave: "61fcc9b044ab7c173ea31eea4c8682447e54269a27af64b8f1dff775db2c11a6"
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
