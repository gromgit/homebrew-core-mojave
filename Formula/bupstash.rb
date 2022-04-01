class Bupstash < Formula
  desc "Easy and efficient encrypted backups"
  homepage "https://bupstash.io"
  url "https://github.com/andrewchambers/bupstash/releases/download/v0.11.0/bupstash-v0.11.0-src+deps.tar.gz"
  sha256 "b763b71aad87e7ae8e9dec06c5de54796ad3cc6e59859374b9eef066d7f2f941"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bupstash"
    sha256 cellar: :any, mojave: "23d6ff97730e740f304389a0b0c6b6c81bc7975513560e03398c004708017754"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"

  resource "man" do
    url "https://github.com/andrewchambers/bupstash/releases/download/v0.11.0/bupstash-v0.11.0-man.tar.gz"
    sha256 "74645f4a243f786261123667e1849085cc2eda095bf3ebbb792cb0195adeeae9"
  end

  def install
    system "cargo", "install", *std_cargo_args

    resource("man").stage do
      man1.install Dir["*.1"]
      man7.install Dir["*.7"]
    end
  end

  test do
    (testpath/"testfile").write("This is a test")

    system bin/"bupstash", "init", "-r", testpath/"foo"
    system bin/"bupstash", "new-key", "-o", testpath/"key"
    system bin/"bupstash", "put", "-k", testpath/"key", "-r", testpath/"foo", testpath/"testfile"

    assert_equal (testpath/"testfile").read,
      shell_output("#{bin}/bupstash get -k #{testpath}/key -r #{testpath}/foo id=*")
  end
end
