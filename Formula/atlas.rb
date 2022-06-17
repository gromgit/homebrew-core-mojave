class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.4.2.tar.gz"
  sha256 "d950e9f665cfb8b556c4f921e9d642e9628c1c8c788fa2b5ef9ddcb32d8751e6"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/atlas"
    sha256 cellar: :any_skip_relocation, mojave: "de01747529d77cd7f39ac91242828e62af936bc5327f82985e6ddd0529d04d1e"
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
