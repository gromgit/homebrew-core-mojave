class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.10.3.tar.gz"
  sha256 "ca1a37c40b8fc7f328f412d19dd54a36180894ac1e6c233b53af84ca23deb0d5"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/virustotal-cli"
    sha256 cellar: :any_skip_relocation, mojave: "a1f089f61b5c2a4595e5e22075354f7948d4b5dbc84e9ed3b0b378e9886dee64"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", "-ldflags",
            "-X cmd.Version=#{version}",
            "-o", bin/"vt", "./vt/main.go"

    generate_completions_from_executable(bin/"vt", "completion", base_name: "vt", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
