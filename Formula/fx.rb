class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/23.0.1.tar.gz"
  sha256 "2a889077829befe39660baf76923652ef37159e7b6ef6a25dd2f4e0a9435f6aa"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fx"
    sha256 cellar: :any_skip_relocation, mojave: "3ae4120ebb388d8e1baba642ff63bddbf93d49bd1e8f9548f6eadd3f8e1ad65a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_equal "42", pipe_output(bin/"fx", 42).strip
  end
end
