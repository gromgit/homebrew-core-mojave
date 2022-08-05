class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.76.tar.gz"
  sha256 "7d91fc411b7363fd8842890c5ed25d6cc4481f76cd48dcac154cd6e99f8c4d7b"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ffsend"
    sha256 cellar: :any_skip_relocation, mojave: "639c60608d4368caee26ff2dbfffdda57edf30ee050a1ddb4af1d443b109381a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "contrib/completions/ffsend.bash"
    fish_completion.install "contrib/completions/ffsend.fish"
    zsh_completion.install "contrib/completions/_ffsend"
  end

  test do
    system "#{bin}/ffsend", "help"

    (testpath/"file.txt").write("test")
    url = shell_output("#{bin}/ffsend upload -Iq #{testpath}/file.txt").strip
    output = shell_output("#{bin}/ffsend del -I #{url} 2>&1")
    assert_match "File deleted", output
  end
end
