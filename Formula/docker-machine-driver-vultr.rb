class DockerMachineDriverVultr < Formula
  desc "Docker Machine driver plugin for Vultr Cloud"
  homepage "https://github.com/janeczku/docker-machine-vultr"
  url "https://github.com/janeczku/docker-machine-vultr/archive/v1.4.0.tar.gz"
  sha256 "f69b1b33c7c73bea4ab1980fbf59b7ba546221d31229d03749edee24a1e7e8b5"
  license "MIT"
  head "https://github.com/janeczku/docker-machine-vultr.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-machine-driver-vultr"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "1fe2412f33a859200d03233ae2c4e074f0c6b82071c20ef89d3e690596aa38f4"
  end


  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/janeczku/docker-machine-vultr").install buildpath.children

    cd "src/github.com/janeczku/docker-machine-vultr" do
      system "make"
      bin.install "build/docker-machine-driver-vultr-v#{version}" => "docker-machine-driver-vultr"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "--vultr-api-endpoint",
      shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver vultr -h")
  end
end
