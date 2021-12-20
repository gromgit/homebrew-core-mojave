class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "c13f99b0ce34cecfaaea448ad134e6293b316128a6b0f67af5e70cc6525f1b6e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/chroma"
    sha256 cellar: :any_skip_relocation, mojave: "0bd6b5c3c9b3f9cb29e0024c237a17dd5638685ea76857580b066a4f2217f827"
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
