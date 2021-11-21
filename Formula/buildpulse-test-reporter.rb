class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "ead1db68b7826eeb302cebf0bdacd25b835b896b43883b57c94a74c0d96fd0cd"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/buildpulse-test-reporter"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "d11167797df91c037581f77092f7755f4c7538cf0036f41ee9818e7ae0c876e1"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd/test-reporter"
  end

  test do
    binary = bin/"buildpulse-test-reporter"
    assert_match version.to_s, shell_output("#{binary} --version")

    fake_dir = "im-not-real"
    assert_match "Received args: #{fake_dir}", shell_output("#{binary} submit #{fake_dir}", 1)
  end
end
