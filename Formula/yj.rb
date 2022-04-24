class Yj < Formula
  desc "CLI to convert between YAML, TOML, JSON and HCL"
  homepage "https://github.com/sclevine/yj"
  url "https://github.com/sclevine/yj/archive/v5.1.0.tar.gz"
  sha256 "9a3e9895181d1cbd436a1b02ccf47579afacd181c73f341e697a8fe74f74f99d"
  license "Apache-2.0"
  head "https://github.com/sclevine/yj.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yj"
    sha256 cellar: :any_skip_relocation, mojave: "383d7e227e597379311079ce87fc30f61c76121fec274665b909dd43dc4c069f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.Version=#{version}", *std_go_args
  end

  test do
    assert_match '{"a":1}', pipe_output("#{bin}/yj -t", "a=1")
  end
end
