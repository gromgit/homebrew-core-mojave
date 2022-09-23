class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.9.0.tar.gz"
  sha256 "b7658a074508c117c2af3a55b7b37abf194f84fe94939c9b6b7ff324696258b9"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tea"
    sha256 cellar: :any_skip_relocation, mojave: "d4bfaab81714db96dfa9af7d485de7255f99dd2bedc40cf732fdd79b6ee35d5c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    bash_completion.install "contrib/autocomplete.sh" => "tea"
    zsh_completion.install "contrib/autocomplete.zsh" => "_tea"

    system bin/"tea", "shellcompletion", "fish"

    if OS.mac?
      fish_completion.install "#{Dir.home}/Library/Application Support/fish/conf.d/tea_completion.fish" => "tea.fish"
    else
      fish_completion.install "#{Dir.home}/.config/fish/conf.d/tea_completion.fish" => "tea.fish"
    end
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/tea pulls", 1)
      No gitea login configured. To start using tea, first run
        tea login add
      and then run your command again.
    EOS
  end
end
