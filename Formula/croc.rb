class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.5.3.tar.gz"
  sha256 "7f8ac260c786bc3f1e3c577e6ac3d3e27d0d8cffa90d7a8d21cec85fe6f22abc"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/croc"
    sha256 cellar: :any_skip_relocation, mojave: "23377f9f3452ec759e7c89f53c925ab9e76650a8f3b1634eb54acdf87a4d0a9a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port=free_port

    fork do
      exec bin/"croc", "relay", "--ports=#{port}"
    end
    sleep 1

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end
