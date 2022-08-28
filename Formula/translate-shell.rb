class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.7.tar.gz"
  sha256 "fe328bff9670a925f6dd6f80629ed92b078edd9a4c3f8414fbb3d921365c59a7"
  license "Unlicense"
  head "https://github.com/soimort/translate-shell.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9ffbfa24a9eb1bb089abe076cf7ae261d9f907f691c6aba360ea528ae00ab3cc"
  end

  depends_on "fribidi"
  depends_on "gawk"
  depends_on "rlwrap"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "make"
    bin.install "build/trans"
    man1.install "man/trans.1"
  end

  def caveats
    <<~EOS
      By default, text-to-speech functionality is provided by macOS's builtin
      `say' command. This functionality may be improved in certain cases by
      installing one of mplayer, mpv, or mpg123, all of which are available
      through `brew install'.
    EOS
  end

  test do
    assert_equal "hello\n",
      shell_output("#{bin}/trans -no-init -b -s es -t en hola").downcase
  end
end
