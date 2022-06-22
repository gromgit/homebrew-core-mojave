class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.5.3.tar.gz"
  sha256 "cf4ce3616d61fc5c1762663d660af9e06d59a15af3a2ce164b7f4c1c5b8aed3a"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/scw"
    sha256 cellar: :any_skip_relocation, mojave: "e93c84e34114fda9534e38ac294d5222e4bb7481342db78c815b3ddf8ac8cce1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    zsh_output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"scw", "autocomplete", "script")
    (zsh_completion/"_scw").write zsh_output

    bash_output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"scw", "autocomplete", "script")
    (bash_completion/"scw").write bash_output

    fish_output = Utils.safe_popen_read({ "SHELL" => "fish" }, bin/"scw", "autocomplete", "script")
    (fish_completion/"scw.fish").write fish_output
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
