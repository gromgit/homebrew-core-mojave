class ReginaRexx < Formula
  desc "Interpreter for Rexx"
  homepage "https://regina-rexx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.9.4/regina-rexx-3.9.4.tar.gz"
  sha256 "a4002237d0c625ded6a270c407643f49738de4eb755b68abdbf69c3f306d18be"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/regina-rexx"
    sha256 mojave: "987a9486936fabcda565455dac9e7ec3003580952ac610ce1ff146685ec2663f"
  end

  def install
    ENV.deparallelize # No core usage for you, otherwise race condition = missing files.
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<~EOS
      #!#{bin}/regina
      Parse Version ver
      Say ver
    EOS
    chmod 0755, testpath/"test"
    assert_match version.to_s, shell_output(testpath/"test")
  end
end
