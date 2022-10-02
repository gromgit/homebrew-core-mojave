class Bupstash < Formula
  desc "Easy and efficient encrypted backups"
  homepage "https://bupstash.io"
  url "https://github.com/andrewchambers/bupstash/releases/download/v0.11.1/bupstash-v0.11.1-src+deps.tar.gz"
  sha256 "9433379491e7552032620789a0f8a702159a0744484e3fd9fe73eb9eb1d71351"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bupstash"
    sha256 cellar: :any, mojave: "f55d288a89e8b478b75952d0a7597eae8d1acbea990c2159b021d5f3c245e1e1"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"

  resource "man" do
    url "https://github.com/andrewchambers/bupstash/releases/download/v0.11.1/bupstash-v0.11.1-man.tar.gz"
    sha256 "abbf79420e15e2619deb379d966e0b118ad67fcd411e52b1e642d8ba80b730bf"
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
