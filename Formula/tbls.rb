class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.56.3.tar.gz"
  sha256 "ca4ce36a4ecb7896385935ea381cf2a4d74bf9a210e1c6fa660329cc6cc7daf3"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tbls"
    sha256 cellar: :any_skip_relocation, mojave: "a235c75a8b99dd6cacf8ea4a8d40e7b3b48c0a6e37192de0715755bfb8ad908f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.rfc3339}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
