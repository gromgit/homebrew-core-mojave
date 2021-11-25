class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.28.0.tar.gz"
  sha256 "05bbfa4dd84b72e55afc3fe56c0fc185d6dd1fa1c4eef56a1559b68341f3d029"
  license "MIT"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fzf"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "87f57192e663e98bf10843e3f98254bb0e9bd9ac8a2939c2c69ba959b4ec1984"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version} -X main.revision=brew"

    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
  end

  def caveats
    <<~EOS
      To install useful keybindings and fuzzy completion:
        #{opt_prefix}/install

      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end
