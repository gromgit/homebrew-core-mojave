class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.5.1.tar.gz"
  sha256 "84bc80900c90d3b3ef0fd9590b9b839c876ffa15ec24ebf230c9a979c4ef5188"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/croc"
    sha256 cellar: :any_skip_relocation, mojave: "cae8edec66d19b5386d748b84488dbabf700c9263fa2d27b2992c0280f529144"
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
