class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "908e0aa7c814da997e731610090732c8d297d178b01e5146f88610fe585e2e92"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gf"
    sha256 cellar: :any_skip_relocation, mojave: "e6adeef55c465d3c40213e4906499ab371b67d50d875bf404a3c914655076087"
  end

  depends_on "go" => :build

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "GoFrame CLI Tool v#{version}, https://goframe.org", output
    assert_match "GoFrame Version: cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
