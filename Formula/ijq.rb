class Ijq < Formula
  desc "Interactive jq"
  homepage "https://sr.ht/~gpanders/ijq/"
  url "https://git.sr.ht/~gpanders/ijq",
      tag:      "v0.4.0",
      revision: "41aabdc0a6801cc31b6828bd677cb5e7766b7dd1"
  license "GPL-3.0-or-later"
  head "https://git.sr.ht/~gpanders/ijq", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ijq"
    sha256 cellar: :any_skip_relocation, mojave: "a04aaefe6a9090d4c1c66a8ef6f0af57f1bfb14255298748fd350ba6ff5b3fed"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build
  depends_on "jq"

  uses_from_macos "expect" => :test

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    ENV["TERM"] = "xterm"

    (testpath/"filterfile.jq").write '["foo", "bar", "baz"] | sort | add'

    (testpath/"ijq.exp").write <<~EOS
      #!/usr/bin/expect -f
      proc succeed {} {
        puts success
        exit 0
      }
      proc fail {} {
        puts failure
        exit 1
      }
      set timeout 5
      spawn ijq -H '' -M -n -f filterfile.jq
      expect {
        barbazfoo   succeed
        timeout     fail
      }
    EOS
    system "expect", "-f", "ijq.exp"
  end
end
