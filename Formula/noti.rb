class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/3.6.0.tar.gz"
  sha256 "7ae07d93e33039fbbe29aa2ecd224ba311d08338f87dd8b45aae70fc459eb8a4"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/noti"
    sha256 cellar: :any_skip_relocation, mojave: "fc5131f938b569e4b0e730a11c3a5b76fd614c4baa66c36bcafadef80bb94d19"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/variadico/noti/internal/command.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/noti/main.go"
    man1.install "docs/man/dist/noti.1"
    man5.install "docs/man/dist/noti.yaml.5"
  end

  test do
    assert_match "noti version #{version}", shell_output("#{bin}/noti --version").chomp
    system bin/"noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
