class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe.git",
      tag:      "v1.4.0",
      revision: "8d7c5f749a0fe3d6073f3f010a538bf6ea4edb48"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/easeprobe"
    sha256 cellar: :any_skip_relocation, mojave: "9ad4ed31eda9b424d85098ce9bceced9e89a89d9d0bc7c6d43a1d2833368b8f3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/megaease/easeprobe/pkg/version.RELEASE=#{version}
      -X github.com/megaease/easeprobe/pkg/version.COMMIT=#{Utils.git_head}
      -X github.com/megaease/easeprobe/pkg/version.REPO=megaease/easeprobe
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/easeprobe"
  end

  test do
    (testpath/"config.yml").write <<~EOS.chomp
      http:
        - name: "brew.sh"
          url: "https://brew.sh"
    EOS

    easeprobe_stdout = (testpath/"easeprobe.log")

    pid = fork do
      $stdout.reopen(easeprobe_stdout)
      exec bin/"easeprobe", "-f", testpath/"config.yml"
    end
    sleep 2
    assert_match "Ready to monitor(http): brew.sh", easeprobe_stdout.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
