class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.10.5.tar.gz"
  sha256 "53410051ad246e452878d7b9de241a7173f588ec2b68f02adb40e7ec01b16912"
  license "MIT"
  head "https://github.com/mbrt/gmailctl.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gmailctl"
    sha256 cellar: :any_skip_relocation, mojave: "2fdd1fe03d894657277097f8806403379ea03790f13393b0ee70a017f2642942"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/gmailctl/main.go"

    generate_completions_from_executable(bin/"gmailctl", "completion")
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1", 1),
      "The credentials are not initialized"

    assert_match version.to_s, shell_output("#{bin}/gmailctl version")
  end
end
