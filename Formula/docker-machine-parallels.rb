class DockerMachineParallels < Formula
  desc "Parallels Driver for Docker Machine"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels.git",
      tag:      "v2.0.1",
      revision: "a1c3d495487413bdd24a562c0edee1af1cfc2f0f"
  license "MIT"
  head "https://github.com/Parallels/docker-machine-parallels.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-machine-parallels"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "ef3f8ed5ce09034340afa11b3e55fa4a3c5ff0dfe7136dd20f20c1dd4f5a5f05"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
  depends_on "docker-machine"
  depends_on :macos

  def install
    system "make", "build"
    bin.install "bin/docker-machine-driver-parallels"
  end

  test do
    assert_match "parallels-memory", shell_output("docker-machine create -d parallels -h")
  end
end
