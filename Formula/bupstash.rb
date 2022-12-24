class Bupstash < Formula
  desc "Easy and efficient encrypted backups"
  homepage "https://bupstash.io"
  url "https://github.com/andrewchambers/bupstash/releases/download/v0.12.0/bupstash-v0.12.0-src+deps.tar.gz"
  sha256 "e3054c03b0d57ba718bd2cab8c24df13153369dea311e5a595d586ad24865793"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bupstash"
    sha256 cellar: :any, mojave: "31068fefeb88a60c6604427d6e1c51847fdbe1ed47139bdfb69cd40bb2e53c7c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"

  resource "man" do
    url "https://github.com/andrewchambers/bupstash/releases/download/v0.12.0/bupstash-v0.12.0-man.tar.gz"
    sha256 "bffe4a9e7c79f03af0255638acfa13fb9f74ed5d6f8987954db1d3164f431629"
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
