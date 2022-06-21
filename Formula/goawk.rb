class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "dccc38d29b552db43262b9876c27e27c7ac0b5658fd34b2866205cdb4bb1a534"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/goawk"
    sha256 cellar: :any_skip_relocation, mojave: "6d0dba5bfe43346c5451035c1c6537744bb4379d83f74d538dae0cafb215ab6f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
