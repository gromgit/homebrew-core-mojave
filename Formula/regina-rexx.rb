class ReginaRexx < Formula
  desc "Interpreter for Rexx"
  homepage "https://regina-rexx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.9.5/regina-rexx-3.9.5.tar.gz"
  sha256 "08e9a9061bee0038cfb45446de20766ffdae50eea37f6642446ec4e73a2abc51"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/regina-rexx"
    rebuild 1
    sha256 mojave: "7cd8a44c8886454337bfa2d53dbb3c95ccfdf74ff60e9fcba94c03be9dd586a9"
  end

  uses_from_macos "libxcrypt"

  def install
    ENV.deparallelize # No core usage for you, otherwise race condition = missing files.
    system "./configure", *std_configure_args,
                          "--with-addon-dir=#{HOMEBREW_PREFIX}/lib/regina-rexx/addons",
                          "--with-brew-addon-dir=#{lib}/regina-rexx/addons"
    system "make"

    install_targets = OS.mac? ? ["installbase", "installbrewlib"] : ["install"]
    system "make", *install_targets
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
