class Mabel < Formula
  desc "Fancy BitTorrent client for the terminal"
  homepage "https://github.com/smmr-software/mabel"
  url "https://github.com/smmr-software/mabel.git",
      tag:      "v0.1.3",
      revision: "fab9619f85a47e17959a7d00316466c1714747c6"
  license "GPL-3.0-or-later"
  head "https://github.com/smmr-software/mabel.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mabel"
    sha256 cellar: :any_skip_relocation, mojave: "90205a0040dc1b92513826b863f02b31e810afef6de2be28e0f1c03b86ca0ec3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    vrsn_out = shell_output("#{bin}/mabel --version")
    assert_match "Mabel #{version}", vrsn_out
    assert_match "Built by: #{tap.user}", vrsn_out

    trnt_out = shell_output("#{bin}/mabel 'test.torrent' 2>&1", 1)
    error_message = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?
      "open /dev/tty: no such device or address"
    else
      "open test.torrent: no such file or directory"
    end
    assert_match error_message, trnt_out
  end
end
