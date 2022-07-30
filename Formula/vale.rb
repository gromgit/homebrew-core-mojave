class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.20.1.tar.gz"
  sha256 "48cb6e37579b83fb75b919021c79e92c6b0519998818bf0080b2c7a53cf5f563"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vale"
    sha256 cellar: :any_skip_relocation, mojave: "0416b3a1afe52a2fac6b2532cd6a9731a686fd3769c6354e07f0412b4c5363a5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
