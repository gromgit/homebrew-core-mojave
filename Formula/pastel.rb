class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  url "https://github.com/sharkdp/pastel/archive/v0.9.0.tar.gz"
  sha256 "473c805de42f6849a4bb14ec103ca007441f355552bdb6ebc80b60dac1f3a95d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/pastel.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pastel"
    sha256 cellar: :any_skip_relocation, mojave: "2211110967120d7ae4bb0d375d9a3fc60df5f4a37cac0dbfacdd82abfc95f791"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath/"completions"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/pastel.bash"
    zsh_completion.install "completions/_pastel"
    fish_completion.install "completions/pastel.fish"
  end

  test do
    output = shell_output("#{bin}/pastel format hex rebeccapurple").strip

    assert_equal "#663399", output
  end
end
