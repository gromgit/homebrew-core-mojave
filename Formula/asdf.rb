class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/v0.9.0.tar.gz"
  sha256 "f2ab54bf1d17e10f17e405c2fac29f0620a66b5c7a5200b5699e50e28ed210c8"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c1733505b491d9d5a9442655c123c68fd3a3b4e102c89bab39898246aa0e405"
  end

  depends_on "autoconf"
  depends_on "automake"
  depends_on "coreutils"
  depends_on "libtool"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    bash_completion.install "completions/asdf.bash"
    fish_completion.install "completions/asdf.fish"
    zsh_completion.install "completions/_asdf"
    libexec.install Dir["*"]
    touch libexec/"asdf_updates_disabled"

    # TODO: Remove these placeholders on 31 August 2022
    bin.write_exec_script libexec/"bin/asdf"
    (prefix/"asdf.sh").write ". #{libexec}/asdf.sh\n"
    (prefix/"asdf.fish").write "source #{libexec}/asdf.fish\n"
    (lib/"asdf.sh").write ". #{libexec}/lib/asdf.sh\n"
    (lib/"asdf.fish").write "source #{libexec}/lib/asdf.fish\n"
  end

  def caveats
    s = "To use asdf, add the following line to your #{shell_profile}:\n"

    s += if preferred == :fish
      "  source #{opt_libexec}/asdf.fish\n\n"
    else
      "  . #{opt_libexec}/asdf.sh\n\n"
    end

    s += "Restart your terminal for the settings to take effect."

    s
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asdf version")
    output = shell_output("#{bin}/asdf plugin-list 2>&1", 1)
    assert_match "No plugins installed", output
    assert_match "Update command disabled.", shell_output("#{bin}/asdf update", 42)
  end
end
