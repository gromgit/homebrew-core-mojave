class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "15289ce536e734767e06816c6bb33537121c3b70c2ecbc3431afe95942bb0fce"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/chroma"
    sha256 cellar: :any_skip_relocation, mojave: "678fd7376a4767017f88728120a6294f30b33d2f6196537c724060fe69b45985"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
