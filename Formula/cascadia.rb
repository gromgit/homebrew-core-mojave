class Cascadia < Formula
  desc "Go cascadia package command-line CSS selector"
  homepage "https://github.com/suntong/cascadia"
  url "https://github.com/suntong/cascadia/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "ff314144fdab70a7347b0c1a27b5e6628abe72827947e3cb571cebd385fd61df"
  license "MIT"
  head "https://github.com/suntong/cascadia.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cascadia"
    sha256 cellar: :any_skip_relocation, mojave: "39f39f9d63779b7815d38fa8b2a1988dac97034a84bd4ab2f19fd3b0340ce2d7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/cascadia --help")

    test_html = "<foo><bar>aaa</bar><baz>bbb</baz></foo>"
    test_css_selector = "foo > bar"
    expected_html_output = "<bar>aaa</bar>"
    assert_equal expected_html_output,
      pipe_output("#{bin}/cascadia --in --out --css '#{test_css_selector}'", test_html).strip
  end
end
