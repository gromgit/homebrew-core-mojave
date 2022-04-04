class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r26.tar.gz"
  sha256 "dccd1ad67d2639e47fe0cbc93d74f202d6d6f0c3759fb0237affb7b1a2b1379e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lf"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "1e66f3915c35218b68d6ee7b9085f31c4e371637f151e75e3eb31fc3c998e51a"
  end

  # Bump to 1.18 on the next release.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
