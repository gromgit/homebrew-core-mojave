class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.7.tar.gz"
  sha256 "5b729b71693434827ebeb4e3955bcc149f3f7280fb1e6600aa1872317eb2785d"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rke"
    sha256 cellar: :any_skip_relocation, mojave: "c6dda0cb0d85cb3c1f0f4eba7391c30eea4189af6c509fd1c89b550bf7e289d7"
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
