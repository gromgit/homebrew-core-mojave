class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "5d6b9986a175ed8ca789e55e42bb4d0f6089b408824b0654b57c7fcb91c06c07"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/chroma"
    sha256 cellar: :any_skip_relocation, mojave: "852eb86da76a5008051699b0ae8f375c52ef983c51dbce58d7ae3bf651a43ac9"
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
