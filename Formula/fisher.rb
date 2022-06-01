class Fisher < Formula
  desc "Plugin manager for the Fish shell"
  homepage "https://github.com/jorgebucaran/fisher"
  url "https://github.com/jorgebucaran/fisher/archive/4.3.2.tar.gz"
  sha256 "202ca657f6b43c5f89ab361447a6045ca7bbe7291a75f814f1fbce3d897bc345"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7575acaffb45e8f056daf794c4a3d622ab2c6b27312af5b095b3830643cfbe42"
  end

  depends_on "fish"

  def install
    fish_function.install "functions/fisher.fish"
    fish_completion.install "completions/fisher.fish"
  end

  test do
    system "#{Formula["fish"].bin}/fish", "-c", "fisher install jethrokuan/z"
    assert_equal File.read(testpath/".config/fish/fish_plugins"), "jethrokuan/z\n"
  end
end
