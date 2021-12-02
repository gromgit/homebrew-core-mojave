require "language/node"

class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://octant.dev"
  url "https://github.com/vmware-tanzu/octant.git",
      tag:      "v0.25.0",
      revision: "223e262201da0eefb320c98756cc84c4bb1a2622"
  license "Apache-2.0"
  head "https://github.com/vmware-tanzu/octant.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/octant"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ab98e0f9a1d999b338bb52cb4a64c0f1ca21808c773ee3a76217b99f29089caf"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["GOFLAGS"] = "-mod=vendor"

    Language::Node.setup_npm_environment

    system "go", "run", "build.go", "go-install"
    system "go", "run", "build.go", "web-build"

    ldflags = ["-X main.version=#{version}",
               "-X main.gitCommit=#{Utils.git_head}",
               "-X main.buildTime=#{time.iso8601}"].join(" ")

    tags = "embedded exclude_graphdriver_devicemapper exclude_graphdriver_btrfs containers_image_openpgp"

    system "go", "build", *std_go_args(ldflags: ldflags),
           "-tags", tags, "-v", "./cmd/octant"
  end

  test do
    fork do
      exec bin/"octant", "--kubeconfig", testpath/"config", "--disable-open-browser"
    end
    sleep 5

    output = shell_output("curl -s http://localhost:7777")
    assert_match "<title>Octant</title>", output, "Octant did not start"
    assert_match version.to_s, shell_output("#{bin}/octant version")
  end
end
