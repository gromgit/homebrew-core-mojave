class V < Formula
  desc "Z for vim"
  homepage "https://github.com/rupa/v"
  url "https://github.com/rupa/v/archive/v1.1.tar.gz"
  sha256 "6483ef1248dcbc6f360b0cdeb9f9c11879815bd18b0c4f053a18ddd56a69b81f"
  revision 1
  head "https://github.com/rupa/v.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/v"
    sha256 cellar: :any_skip_relocation, mojave: "18192fa0168a1a7750f041306e4b308bd0dc36373c8dc8faac7e54e94cfbdd81"
  end

  uses_from_macos "vim"

  def install
    bin.install "v"
    man1.install "v.1"
  end

  test do
    (testpath/".vimrc").write "set viminfo='25,\"50,n#{testpath}/.viminfo"
    system "vim", "-u", testpath/".vimrc", "+wq", "test.txt"
    assert_equal "#{testpath}/test.txt", shell_output("#{bin}/v -a --debug").chomp
  end
end
