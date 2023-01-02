class DockerMachineDriverVmware < Formula
  desc "VMware Fusion & Workstation docker-machine driver"
  homepage "https://www.vmware.com/products/personal-desktop-virtualization.html"
  url "https://github.com/machine-drivers/docker-machine-driver-vmware.git",
      tag:      "v0.1.5",
      revision: "faa4b93573820340d44333ffab35e2beee3f984a"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-machine-driver-vmware"
    rebuild 5
    sha256 cellar: :any_skip_relocation, mojave: "4888a23bddff541c7a6fb5fbee6401a73ae814040dd62a01a6dc5e3b5a380eb4"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
  depends_on "docker-machine"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    docker_machine = Formula["docker-machine"].opt_bin/"docker-machine"
    output = shell_output("#{docker_machine} create --driver vmware -h")
    assert_match "engine-env", output
  end
end
