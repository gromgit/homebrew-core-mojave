class Fisher < Formula
  desc "Plugin manager for the Fish shell"
  homepage "https://github.com/jorgebucaran/fisher"
  url "https://github.com/jorgebucaran/fisher/archive/4.3.4.tar.gz"
  sha256 "8c8d48a390ca94f330f7089dd4bd3883ffd4d51b380622cd851ce7a597aae5b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4cf7a83d5b3bfe2db60ac3b7073663be4a7cb18d5145858a4eecefdd8a090e6f"
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
