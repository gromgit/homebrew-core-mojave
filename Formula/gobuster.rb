class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "6c1d7a3aa9604d90ca818d6fc7a0b09501e419ecd4ab7665566c52fd0981b52d"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gobuster"
    sha256 cellar: :any_skip_relocation, mojave: "b2f4cb2167a52316f009dc1353b9859b88aae67179bcc71bf25c1c37ea3421e7"
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

    assert_match version.major_minor.to_s, shell_output(bin/"gobuster version")
  end
end
