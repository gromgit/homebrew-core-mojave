class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.5.0.tar.gz"
  sha256 "0e250ecebc72753991a3442e48f9caadfae2467430a81595b79b5443e2ff523b"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/croc"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "eceacf696e0fbe84989df0acb518ec16edd23a10e51a8a28d704b8784151e4a6"
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
