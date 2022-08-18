class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.4.0.tar.gz"
  sha256 "f462ea2e6ab3e66d83dd59fab22066798693c972b2ef82b6c27ed5c630746d13"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/goctl"
    sha256 cellar: :any_skip_relocation, mojave: "c49a91eaf6401cc1fc880b946f0dc5c187b2c28dfcae1b284094648807590742"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"goctl"), "goctl.go"
    end
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    system bin/"goctl", "template", "init", "--home=#{testpath}/goctl-tpl-#{version}"
    assert_predicate testpath/"goctl-tpl-#{version}", :exist?, "goctl install fail"
  end
end
