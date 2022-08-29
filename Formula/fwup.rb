class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.9.1/fwup-1.9.1.tar.gz"
  sha256 "fc76f74dadbde53cdc9786737983f9dcdd7da3dbcc4dbd683404c8e136112741"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fwup"
    sha256 cellar: :any, mojave: "42053e8ea73cf8107c95110bda5459889192bbd1178f81bca094b150b408b193"
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
