class Authoscope < Formula
  desc "Scriptable network authentication cracker"
  homepage "https://github.com/kpcyrd/authoscope"
  url "https://github.com/kpcyrd/authoscope/archive/v0.8.1.tar.gz"
  sha256 "fd70d3d86421ac791362bf8d1063a1d5cd4f5410b0b8f5871c42cb48c8cc411a"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/authoscope"
    sha256 cellar: :any_skip_relocation, mojave: "76cb0a0c8fdb6adf25b714ab47785da1cdc066a4a009ab97cf79cbaf10d78027"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", *std_cargo_args
    man1.install "docs/authoscope.1"

    bash_output = Utils.safe_popen_read(bin/"authoscope", "completions", "bash")
    (bash_completion/"authoscope").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"authoscope", "completions", "zsh")
    (zsh_completion/"_authoscope").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"authoscope", "completions", "fish")
    (fish_completion/"authoscope.fish").write fish_output
  end

  test do
    (testpath/"true.lua").write <<~EOS
      descr = "always true"

      function verify(user, password)
          return true
      end
    EOS
    system bin/"authoscope", "run", "-vvx", testpath/"true.lua", "foo"
  end
end
