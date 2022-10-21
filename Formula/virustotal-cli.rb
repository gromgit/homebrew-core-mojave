class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.10.3.tar.gz"
  sha256 "ca1a37c40b8fc7f328f412d19dd54a36180894ac1e6c233b53af84ca23deb0d5"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/virustotal-cli"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "9450f6f10b3c8b81a1c0f124f779989445d3c1a07f24b002ab71a0853cc0aab8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"vt", ldflags: "-X cmd.Version=#{version}"), "./vt/main.go"

    generate_completions_from_executable(bin/"vt", "completion", base_name: "vt", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
