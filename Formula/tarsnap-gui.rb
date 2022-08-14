class TarsnapGui < Formula
  desc "Cross-platform GUI for the Tarsnap command-line client"
  homepage "https://github.com/Tarsnap/tarsnap-gui/wiki"
  url "https://github.com/Tarsnap/tarsnap-gui/archive/v1.0.2.tar.gz"
  sha256 "3b271f474abc0bbeb3d5d62ee76b82785c7d64145e6e8b51fa7907b724c83eae"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Tarsnap/tarsnap-gui.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tarsnap-gui"
    sha256 cellar: :any, mojave: "500ada372b65be012a3cf2e0db2eb8d7935d6cc54ca7b56bdbca872f2b841c78"
  end

  depends_on "qt@5"
  depends_on "tarsnap"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # qt@5 is built with GCC

  # Work around build error: Set: Entry, ":CFBundleGetInfoString", Does Not Exist
  # Issue ref: https://github.com/Tarsnap/tarsnap-gui/issues/557
  patch :DATA

  def install
    system "qmake"
    system "make"
    if OS.mac?
      prefix.install "Tarsnap.app"
      bin.install_symlink prefix/"Tarsnap.app/Contents/MacOS/Tarsnap" => "tarsnap-gui"
    else
      bin.install "tarsnap-gui"
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    system bin/"tarsnap-gui", "--version"
  end
end

__END__
diff --git a/Tarsnap.pro b/Tarsnap.pro
index 9954fc5c..560621b1 100644
--- a/Tarsnap.pro
+++ b/Tarsnap.pro
@@ -131,5 +131,8 @@ osx {
 
     # Add VERSION to the app bundle.  (Why doesn't qmake do this?)
     INFO_PLIST_PATH = $$shell_quote($${OUT_PWD}/$${TARGET}.app/Contents/Info.plist)
-    QMAKE_POST_LINK += /usr/libexec/PlistBuddy -c \"Set :CFBundleGetInfoString $${VERSION}\" $${INFO_PLIST_PATH} ;
+    QMAKE_POST_LINK += /usr/libexec/PlistBuddy \
+                            -c \"Add :CFBundleVersionString string $${VERSION}\" \
+                            -c \"Add :CFBundleShortVersionString string $${VERSION}\" \
+                            $${INFO_PLIST_PATH} ;
 }
