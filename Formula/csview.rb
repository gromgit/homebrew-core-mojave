class Csview < Formula
  desc "High performance csv viewer for cli"
  homepage "https://github.com/wfxr/csview"
  url "https://github.com/wfxr/csview/archive/v1.0.1.tar.gz"
  sha256 "34df6838dd9407197511887cdc9b2a3ed08b4b508f9c6bb660def326ea953e8c"
  license any_of: ["MIT", "Apache-2.0"]

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/csview"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "7b667d3adcdde3cf1a4e7df009236ddd819a33a11200306fab6ab78908c4f33d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    zsh_completion.install  "completions/zsh/_csview"
    bash_completion.install "completions/bash/csview.bash"
    fish_completion.install "completions/fish/csview.fish"
  end

  test do
    (testpath/"test.csv").write("a,b,c\n1,2,3")
    assert_equal <<~EOS, shell_output("#{bin}/csview #{testpath}/test.csv")
      ┌───┬───┬───┐
      │ a │ b │ c │
      ├───┼───┼───┤
      │ 1 │ 2 │ 3 │
      └───┴───┴───┘
    EOS
  end
end
