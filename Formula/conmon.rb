class Conmon < Formula
  desc "OCI container runtime monitor"
  homepage "https://github.com/containers/conmon"
  url "https://github.com/containers/conmon/archive/refs/tags/v2.0.30.tar.gz"
  sha256 "4b0a98fbe8a63c42f60edac25c19aa6606caa7b1e4fe7846fc7f7de0b566ba25"
  license "Apache-2.0"


  depends_on "go" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "libseccomp"
  depends_on :linux
  depends_on "systemd"

  def install
    system "make", "install", "PREFIX=#{prefix}", "LIBEXECDIR=#{libexec}"
  end

  test do
    assert_match "conmon: Container ID not provided. Use --cid", shell_output("conmon 2>&1", 1)
  end
end
