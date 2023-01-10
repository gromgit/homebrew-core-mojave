class Htmltest < Formula
  desc "HTML validator written in Go"
  homepage "https://github.com/wjdp/htmltest"
  url "https://github.com/wjdp/htmltest/archive/v0.17.0.tar.gz"
  sha256 "2c89e56c837f4d715db9816942e007c973ba58de53d249abc80430c4b7e72f88"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/htmltest"
    sha256 cellar: :any_skip_relocation, mojave: "4c8c1e188fa8d1ba5f6c1f9c2187099a077267f90895ec9123e537c1b476a4ff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.date=#{time.iso8601}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"test.html").write <<~EOS
      <!DOCTYPE html>
      <html>
        <body>
          <nav>
          </nav>
          <article>
            <p>Some text</p>
          </article>
        </body>
      </html>
    EOS
    assert_match "htmltest started at", shell_output("#{bin}/htmltest test.html")
  end
end
