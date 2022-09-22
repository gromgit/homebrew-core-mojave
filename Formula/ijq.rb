class Ijq < Formula
  desc "Interactive jq"
  homepage "https://sr.ht/~gpanders/ijq/"
  url "https://git.sr.ht/~gpanders/ijq",
      tag:      "v0.4.1",
      revision: "22034bea72c80db75cb8aa9fdd5808940bd45fd4"
  license "GPL-3.0-or-later"
  head "https://git.sr.ht/~gpanders/ijq", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ijq"
    sha256 cellar: :any_skip_relocation, mojave: "a4fa2ec501b6f34dd9629d3ed49a9c083dc51fe4f214a39997d08e062710578e"
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
