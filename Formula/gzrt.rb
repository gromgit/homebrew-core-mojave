class Gzrt < Formula
  desc "Gzip recovery toolkit"
  homepage "https://www.urbanophile.com/arenn/coding/gzrt/gzrt.html"
  url "https://www.urbanophile.com/arenn/coding/gzrt/gzrt-0.8.tar.gz"
  sha256 "b0b7dc53dadd8309ad9f43d6d6be7ac502c68ef854f1f9a15bd7f543e4571fee"

  livecheck do
    url :homepage
    regex(/href=.*?gzrt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46794bf9bc734a2a73e7f7b8f9bb16825249bed562bd516a97aa8b2b3349b264"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1bc6db3fef40f0c48ceac080ee84108364cf4ff1d94bb1423c1be5b2f14bc96"
    sha256 cellar: :any_skip_relocation, monterey:       "003e9f13cb64da84793030b3b224e9dc2083b97b7bae69527857bb359f856331"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f9f146178364bb1306a145076a4c79f01f1ba08726b2e90a022597fe34b63f9"
    sha256 cellar: :any_skip_relocation, catalina:       "d1d5378de11679a973ce6a5893984b0431f7ad62f369215814927cdb5fbf6678"
    sha256 cellar: :any_skip_relocation, mojave:         "4d2f5fca0f32dd8a88d7aba3d8e6f926d89f74fa1748b9e7f618bdc76e3500fe"
    sha256 cellar: :any_skip_relocation, high_sierra:    "2e7f8e8743943f1e83c4b1ed6372fa3c4cab00f7a090dbb4f967b7fade1e5e20"
    sha256 cellar: :any_skip_relocation, sierra:         "da5c89596737f514900f32986dd9eb32f010c6c1b9f1643dd03a07eae7e383a7"
    sha256 cellar: :any_skip_relocation, el_capitan:     "01df00fd35c6eaee9d32da4644d694ce33deda79a9c3da0284b52694f94a9515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "befaf922391daf55b95098ef2c66c02fcd04813517cef56c60caf3cd1297d986"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "gzrecover"
    man1.install "gzrecover.1"
  end

  test do
    filename = "data.txt"
    fixed_filename = "#{filename}.recovered"
    path = testpath/filename
    fixed_path = testpath/fixed_filename

    original_contents = "." * 1000
    path.write original_contents

    # Compress data into archive
    gzip path
    refute_predicate path, :exist?

    # Corrupt the archive to test the recovery process
    File.open("#{path}.gz", "r+b") do |file|
      file.seek(11)
      data = file.read(1).unpack1("C*")
      data = ~data
      file.write([data].pack("C*"))
    end

    # Verify that file corruption is detected and attempt to recover
    system bin/"gzrecover", "-v", "#{path}.gz"

    # Verify that recovered data is reasonably close - unlike lziprecover,
    # this process is not perfect, even for small errors
    assert_match original_contents, fixed_path.read
  end
end
