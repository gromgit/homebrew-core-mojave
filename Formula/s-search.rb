class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.6.6.tar.gz"
  sha256 "d91c8d2935f55dc6f241b7abc0325863846bdeac07a8f3bfa99b4a932d20ace3"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/s-search"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "6db918d882a6fce5775a13f62a9c824db42874a445f05bc8135aa1228634c4c3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"s"

    generate_completions_from_executable(bin/"s", "--completion", base_name: "s")
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
