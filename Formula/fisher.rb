class Fisher < Formula
  desc "Plugin manager for the Fish shell"
  homepage "https://github.com/jorgebucaran/fisher"
  url "https://github.com/jorgebucaran/fisher/archive/4.4.2.tar.gz"
  sha256 "619498141f0557ea7eeb4438a97c45748ea5d4c3645340b5464ebb4622af3f64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86f35339a83f2985b49de0effa29cb19a3fc19494f030f022b72ba9ba06eb9e6"
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
