class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.6.2.tar.gz"
  sha256 "af1889daca1cd71445975aebb80dc416b01b1e8d63cd261a79a5dd1a3fd74b29"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/croc"
    sha256 cellar: :any_skip_relocation, mojave: "38dedce316996a364017623a5c9cbcf43bc3c9883831e4dc0c6b71d7b15a5441"
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
