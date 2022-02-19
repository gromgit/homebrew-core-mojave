class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/v1.5.1.tar.gz"
  sha256 "dd2671e517e5dca4fe9d322dcea7cc16ab83b5d705bce13e0e9c82d43a56fb59"
  license "MIT"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jd"
    sha256 cellar: :any_skip_relocation, mojave: "fae8015c755feea0f99d18170fd5bb2d11033dee11f42bd48d918a763a7b8a70"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"a.json").write('{"foo":"bar"}')
    (testpath/"b.json").write('{"foo":"baz"}')
    (testpath/"c.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    output = shell_output("#{bin}/jd a.json b.json", 1)
    assert_equal output, expected
    assert_empty shell_output("#{bin}/jd b.json c.json")
  end
end
