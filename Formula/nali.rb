class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/v0.5.3.tar.gz"
  sha256 "e47c330bd66f6969b625571843451913f5667a25b2852e254ab028b3f3ed575b"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nali"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "be18bbcaf0c60a4841416d2662f6cba418ce8bc8e9732b0be7b91bf0a299738f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"nali", "completion")
  end

  test do
    ip = "1.1.1.1"
    # Default database used by program is in Chinese, while downloading an English one
    # requires an third-party account.
    # This example reads "Australia APNIC/CloudFlare Public DNS Server".
    assert_match "#{ip} [澳大利亚 APNIC/CloudFlare公共DNS服务器]", shell_output("#{bin}/nali #{ip}")
  end
end
