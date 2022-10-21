class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.6.7.tar.gz"
  sha256 "a175e53e2d9c3b990a963b86b285a258ca5533c78fc930cd01b82f4d9dccfec0"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/s-search"
    sha256 cellar: :any_skip_relocation, mojave: "99a4de96bdecdd35b6d7bc16055694d0ec1bd6089022870c61765e593f8f875b"
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
