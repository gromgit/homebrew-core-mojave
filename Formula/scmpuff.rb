class Scmpuff < Formula
  desc "Adds numbered shortcuts for common git commands"
  homepage "https://mroth.github.io/scmpuff/"
  url "https://github.com/mroth/scmpuff/archive/v0.4.0.tar.gz"
  sha256 "2f43ab94a4027b114cde4232c5c91722bc2d7eb44b4d04ff03565fa39b642014"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/scmpuff"
    sha256 cellar: :any_skip_relocation, mojave: "3d3eda957b4c151e85012b2ca71c7a29b3c8c1318bc087c00cd9404a343a4a04"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -v -X main.VERSION=#{version}"
  end

  test do
    ENV["e1"] = "abc"
    assert_equal "abc", shell_output("#{bin}/scmpuff expand 1").strip
  end
end
