class Mqttui < Formula
  desc "Subscribe to a MQTT Topic or publish something quickly from the terminal"
  homepage "https://github.com/EdJoPaTo/mqttui"
  url "https://github.com/EdJoPaTo/mqttui/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "f17914822d05797a8e46447bc7cd0a649e083ee950d295db3c683d07f50269d0"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mqttui"
    sha256 cellar: :any_skip_relocation, mojave: "af943092928e522a23844803bfd975a3bcce62d838ac77af68a7b42799268522"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    zsh_completion.install "target/completions/_mqttui"
    bash_completion.install "target/completions/mqttui.bash"
    fish_completion.install "target/completions/mqttui.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mqttui --version")
    assert_match "Connection refused", shell_output("#{bin}/mqttui --broker mqtt://127.0.0.1 2>&1", 101)
  end
end
