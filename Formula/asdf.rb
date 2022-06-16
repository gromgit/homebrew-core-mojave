class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "a097d40888c276cb20e1489a3da6573dd9d184d8e6518c5f8177d3c2c1066f57"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "615cab908dd9c0c0e6ad2bf4734e1469d11ec7623a2491d406c63a2779806f02"
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
