class TreCommand < Formula
  desc "Tree command, improved"
  homepage "https://github.com/dduan/tre"
  url "https://github.com/dduan/tre/archive/v0.4.0.tar.gz"
  sha256 "280243cfa837661f0c3fff41e4a63c6768631073c9f6ce9982d9ed08e038788a"
  license "MIT"
  head "https://github.com/dduan/tre.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tre-command"
    sha256 cellar: :any_skip_relocation, mojave: "8d739ab20a06af2611d1cf3135856cca7550c761abe5ca895f7cdc3144eed81a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manual/tre.1"
  end

  test do
    (testpath/"foo.txt").write("")
    assert_match("── foo.txt", shell_output("#{bin}/tre"))
  end
end
