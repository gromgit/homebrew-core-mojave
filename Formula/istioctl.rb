class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.12.2",
      revision: "af0d66fd0aa363e9a7b0164f3a94ba36252fe60f"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/istioctl"
    sha256 cellar: :any_skip_relocation, mojave: "c288cd0a2e944ef46e44e2b68479baf163cad3c689938c7fe3c373eeed8ea40e"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  # Fix https://github.com/istio/istio/issues/35831
  # remove in next release
  patch do
    url "https://github.com/istio/istio/commit/6d9c69f10431bca2ee2beefcfdeaad5e5f62071b.patch?full_index=1"
    sha256 "47e175fc0ac5e34496c6c0858eefbc31e45073dad9683164f7a21c74dbaa6055"
  end

  def install
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    system "make", "istioctl"
    bin.install "out/#{os}_#{arch}/istioctl"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"istioctl", "completion", "bash")
    (bash_completion/"istioctl").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"istioctl", "completion", "zsh")
    (zsh_completion/"_istioctl").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"istioctl", "completion", "fish")
    (fish_completion/"istioctl.fish").write output
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
