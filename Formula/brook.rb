class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20220401.tar.gz"
  sha256 "cd3c467d23f4677c51e6764e0a3203cf39ac6c1081203bfd9f5c79680317be22"
  license "GPL-3.0-only"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/brook"
    sha256 cellar: :any_skip_relocation, mojave: "d7a4ed1fd9d9cc4ea46bd19ccad226ae662d89b096a936dea7b3e64bbc140d10"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/brook"
  end

  test do
    output = shell_output "#{bin}/brook link --server 1.2.3.4:56789 --password hello"
    assert_match "brook://server?address=&insecure=&name=&password=hello&server=1.2.3.4%3A56789&username=", output
  end
end
