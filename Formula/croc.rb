class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.5.2.tar.gz"
  sha256 "9fcbb82fa78122b0a2279fe9b4c4c7ff6af7b0599f275c04481ad5ed162d2952"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/croc"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "af2ccd59e431f55c2f9feb77ff0220a7c947f5d18072f7d8030cf7c05d3c087c"
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
