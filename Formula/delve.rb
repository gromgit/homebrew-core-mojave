class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.20.1.tar.gz"
  sha256 "a10aa97d3f6b6219877a73dd305d511442ad0caab740de76fc005796a480de93"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/delve"
    sha256 cellar: :any_skip_relocation, mojave: "458f5282c16034fe9df01d9bfbec2e2b9ec9acfe7fe4c059df3834fcc475da27"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
