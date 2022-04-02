class DockerMachineDriverVmware < Formula
  desc "VMware Fusion & Workstation docker-machine driver"
  homepage "https://www.vmware.com/products/personal-desktop-virtualization.html"
  url "https://github.com/machine-drivers/docker-machine-driver-vmware.git",
      tag:      "v0.1.5",
      revision: "faa4b93573820340d44333ffab35e2beee3f984a"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-machine-driver-vmware"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "8c82816b91e080003ac10e1eb43144fd1e46f5e8cc520cf948f606b9baa6656f"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    dir = buildpath/"src/github.com/machine-drivers/docker-machine-driver-vmware"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", "#{bin}/docker-machine-driver-vmware",
            "-ldflags", "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    docker_machine = Formula["docker-machine"].opt_bin/"docker-machine"
    output = shell_output("#{docker_machine} create --driver vmware -h")
    assert_match "engine-env", output
  end
end
