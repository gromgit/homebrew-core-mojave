class Mabel < Formula
  desc "Fancy BitTorrent client for the terminal"
  homepage "https://github.com/smmr-software/mabel"
  url "https://github.com/smmr-software/mabel.git",
      tag:      "v0.1.4",
      revision: "9232e54a58602b9b128a6070b84295c29aa24b27"
  license "GPL-3.0-or-later"
  head "https://github.com/smmr-software/mabel.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mabel"
    sha256 cellar: :any_skip_relocation, mojave: "63eb9650a135200681124dbd86a30d6a40c6d95e8507c7653fc2320d82a4c51a"
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
