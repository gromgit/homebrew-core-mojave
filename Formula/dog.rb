class Dog < Formula
  desc "Command-line DNS client"
  homepage "https://dns.lookup.dog/"
  url "https://github.com/ogham/dog/archive/v0.1.0.tar.gz"
  sha256 "82387d38727bac7fcdb080970e84b36de80bfe7923ce83f993a77d9ac7847858"
  license "EUPL-1.2"
  head "https://github.com/ogham/dog.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dog"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "381602ce73d1eec082a70017ed4dd6b325eecdeeaefa7b051be2f438ef0fb13b"
  end


  depends_on "just" => :build
  depends_on "pandoc" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "completions/dog.bash" => "dog"
    zsh_completion.install "completions/dog.zsh" => "_dog"
    fish_completion.install "completions/dog.fish"
    system "just", "man"
    man1.install "target/man/dog.1"
  end

  test do
    output = shell_output("#{bin}/dog dns.google A --seconds --color=never")
    assert_match(/^A\s+dns\.google\.\s+\d+\s+8\.8\.4\.4/, output)
    assert_match(/^A\s+dns\.google\.\s+\d+\s+8\.8\.8\.8/, output)
  end
end
