class Run < Formula
  desc "Easily manage and invoke small scripts and wrappers"
  homepage "https://github.com/TekWizely/run"
  url "https://github.com/TekWizely/run/archive/v0.9.1.tar.gz"
  sha256 "39aad9167c73101839749d27bd8c915bfd8e4a26ed21d729981b646c2c171ebf"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/run"
    sha256 cellar: :any_skip_relocation, mojave: "9b941c243b7cfc032c47ea6fc2825ed0df9e46902a3ce9d86d0329702af12082"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-ldflags", "-w -s", "-o", bin/name
  end

  test do
    text = "Hello Homebrew!"
    task = "hello"
    (testpath/"Runfile").write <<~EOS
      #{task}:
        echo #{text}
    EOS
    assert_equal text, shell_output("#{bin}/#{name} #{task}").chomp
  end
end
