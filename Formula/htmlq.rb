class Htmlq < Formula
  desc "Uses CSS selectors to extract bits content from HTML files"
  homepage "https://github.com/mgdm/htmlq"
  url "https://github.com/mgdm/htmlq/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "c2954c0fcb3ada664b14834646aa0a2c4268683cc51fd60d47a71a9f7e77d4b9"
  license "MIT"
  head "https://github.com/mgdm/htmlq.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/htmlq"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "1f81dcdcee62fedd4893e76b675bf7f7364fb79c8385a5fa3571fc2f5e0bb036"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.html").write <<~EOS
      <!doctype html>
      <html>
        <head>
            <title>Example Domain</title>
            <meta charset="utf-8" />
            <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
        </head>
        <body>
            <div>
              <h1>Example Domain</h1>
              <p>This domain is for use in illustrative examples in documents. You may use this domain in literature without prior coordination or asking for permission.</p>
              <p><a href="https://www.iana.org/domains/example">More information...</a></p>
            </div>
        </body>
      </html>
    EOS

    test_html = testpath/"test.html"
    assert_equal "More information...\n", pipe_output("#{bin}/htmlq -t p a", test_html.read)
    assert_equal "Example Domain\n", pipe_output("#{bin}/htmlq -t h1:first-child", test_html.read)
  end
end
