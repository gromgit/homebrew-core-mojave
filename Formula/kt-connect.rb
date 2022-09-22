class KtConnect < Formula
  desc "Toolkit for integrating with kubernetes dev environment more efficiently"
  homepage "https://alibaba.github.io/kt-connect"
  url "https://github.com/alibaba/kt-connect/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "c29d4d9a18defdd8485adfe3a75b2887b42544fedd404073844629666bb28c9f"
  license "GPL-3.0-or-later"
  head "https://github.com/alibaba/kt-connect.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kt-connect"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "7e918c24c10fa88839e5051809e50d385ceed86b6463efd4e1693811bfcd41c6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"ktctl"), "./cmd/ktctl"

    generate_completions_from_executable(bin/"ktctl", "completion", base_name: "ktctl")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ktctl --version")
    # Should error out as exchange require a service name
    assert_match "name of service to exchange is required", shell_output("#{bin}/ktctl exchange 2>&1")
  end
end
