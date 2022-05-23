class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.4.1.tar.gz"
  sha256 "f6927b160eb665d3648c997f34ae06acb5a17dd93ffb5aa3b1ed614d83d87915"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/atlas"
    sha256 cellar: :any_skip_relocation, mojave: "cbcd83864f4226a64e4c3fe72bf8e60c9089b7a00b98765b8077f3d16d08b10c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlascmd.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/atlas"

    bash_output = Utils.safe_popen_read(bin/"atlas", "completion", "bash")
    (bash_completion/"atlas").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"atlas", "completion", "zsh")
    (zsh_completion/"_atlas").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"atlas", "completion", "fish")
    (fish_completion/"atlas.fish").write fish_output
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
