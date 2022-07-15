class Mle < Formula
  desc "Flexible terminal-based text editor"
  homepage "https://github.com/adsr/mle"
  url "https://github.com/adsr/mle/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "569316485fa3775d0bb7559ac176a63adb29467c7098b14c0072c821feb6226b"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mle"
    sha256 cellar: :any, mojave: "534f0f5fc5eae9339bfcfe4b3d355d4a3e6e70d8f7535d74f65702a4ed1df323"
  end

  depends_on "uthash" => :build
  depends_on "lua"
  depends_on "pcre"

  def install
    # TUI hangs on macOS due to https://github.com/adsr/mle/issues/71
    # Fix implemented upstream, extra flag should not be needed on next release
    ENV.append_to_cflags "-DTB_OPT_SELECT" if OS.mac?

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    output = pipe_output("#{bin}/mle -M 'test C-e space w o r l d enter' -p test", "hello")
    assert_equal "hello world\n", output
  end
end
