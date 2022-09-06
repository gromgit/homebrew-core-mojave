class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/22.08/helix-22.08-source.tar.xz"
  sha256 "2c96c00d2c7df98d4426884ee3b217aaadb985f3301f5399e2436db6440373a3"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/helix"
    sha256 cellar: :any, mojave: "49867fe8a521afbd9d8bd7448617a18f987c8b133455670a6f7f61da8745762b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

  def install
    system "cargo", "install", "-vv", *std_cargo_args(root: libexec, path: "helix-term")
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"

    (bin/"hx").write_env_script(libexec/"bin/hx", HELIX_RUNTIME: libexec/"runtime")

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hx -V")
    assert_match "post-modern text editor", shell_output("#{bin}/hx -h")
  end
end
