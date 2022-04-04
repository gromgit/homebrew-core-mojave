class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.8.9.tar.gz"
  sha256 "37e1b9aa4571f98a102b4f7322d7f581c608c0fcd50542dfaa7af742184fb1dc"
  license "MIT"
  head "https://github.com/mattn/jvgrep.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jvgrep"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "42c29dcb8cdd9f8898406a341c2375527501262ca77182fb2d3b7464a4972820"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
