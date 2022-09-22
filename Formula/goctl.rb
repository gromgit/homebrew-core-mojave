class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.4.1.tar.gz"
  sha256 "019cbb71d900903656282e448fca8ffa45b6288a3f50e7295b5a4cd68ab0a3f0"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/goctl"
    sha256 cellar: :any_skip_relocation, mojave: "6cab91f6caa0d13234fae7823a44e35f2e33b567df6a0820d22938fa91b9d089"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"goctl"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    system bin/"goctl", "template", "init", "--home=#{testpath}/goctl-tpl-#{version}"
    assert_predicate testpath/"goctl-tpl-#{version}", :exist?, "goctl install fail"
  end
end
