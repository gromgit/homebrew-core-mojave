class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "63094d24b79622d798f1aed2e497c8a6dd2bbeaa4fda7162ec71bc7070bf1a61"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gobuster"
    sha256 cellar: :any_skip_relocation, mojave: "7342ea5f171d3c7ec7f756b7d18defb7733ddd34ac7b4b4d3e107fa02afadd6d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"gobuster", "completion")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/gobuster dir -u https://buffered.io -w words.txt 2>&1")
    assert_match "Finished", output

    assert_match version.to_s, shell_output(bin/"gobuster version")
  end
end
