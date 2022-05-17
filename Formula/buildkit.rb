class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.10.3",
      revision: "c8d25d9a103b70dc300a4fd55e7e576472284e31"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/buildkit"
    sha256 cellar: :any_skip_relocation, mojave: "23daefa4026fc81741d5ddd60130c80594b3858132f6ae4ccaa203c2a3e16b01"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_head
    ldflags = %W[
      -s -w
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", "-trimpath",
      "-ldflags", ldflags.join(" "), "-o", bin/"buildctl", "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)
  end
end
