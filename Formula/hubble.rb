class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "4b113cd0b89b57d6e59d3596ede6c04a731c00b3fbff8c2641808bcb31b5faa9"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hubble"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "503a719b0d2ffc9df8878526a7ca5bd7a146c7fbb8697ff85b777a40c0ac939a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"hubble", "completion")
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
  end
end
