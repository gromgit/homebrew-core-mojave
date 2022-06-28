class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.14.tar.gz"
  sha256 "1166fc748d78e1a6ab2386d0b1e2f465512b64b6eb5eb6ff31f52e345ee3304c"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/actionlint"
    sha256 cellar: :any_skip_relocation, mojave: "a773371ba12133a957968a65310fa190a68bcd023c6102666ec924ec3e59ea2d"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/rhysd/actionlint.version=#{version}"), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    (testpath/"action.yaml").write <<~EOS
      name: Test
      on: push
      jobs:
        test:
          steps:
            - run: actions/checkout@v2
    EOS

    assert_match "\"runs-on\" section is missing in job", shell_output(bin/"actionlint #{testpath}/action.yaml", 1)
  end
end
