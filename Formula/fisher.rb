class Fisher < Formula
  desc "Plugin manager for the Fish shell"
  homepage "https://github.com/jorgebucaran/fisher"
  url "https://github.com/jorgebucaran/fisher/archive/4.3.0.tar.gz"
  sha256 "6235cfc636c8d52f11feca9f4931656a9c6602659b06df8dba5a3606d37f8c28"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "958d97d06ad998382f7c9f77d7c4861c6b76542e4438660700fab7b2ddffb5f1"
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
