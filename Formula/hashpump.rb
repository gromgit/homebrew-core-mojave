class Hashpump < Formula
  desc "Tool to exploit hash length extension attack"
  homepage "https://github.com/bwall/HashPump"
  url "https://github.com/bwall/HashPump/archive/v1.2.0.tar.gz"
  sha256 "d002e24541c6604e5243e5325ef152e65f9fcd00168a9fa7a06ad130e28b811b"
  license "MIT"
  revision 6

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hashpump"
    rebuild 1
    sha256 cellar: :any, mojave: "add131092e84f212be9bdba646f7b057a921b0f234fb63220543f10512737fe6"
  end

  depends_on "openssl@1.1"
  depends_on "python@3.11"

  # Remove on next release
  patch do
    url "https://github.com/bwall/HashPump/commit/1d76a269d18319ea3cc9123901ea8cf240f7cc34.patch?full_index=1"
    sha256 "ffc978cbc07521796c0738df77a3e40d79de0875156f9440ef63eca06b2e2779"
  end

  # Fix compatibility with Python 3.10 and later.
  # SystemError: PY_SSIZE_T_CLEAN macro must be defined for '#' formats
  # PR ref: https://github.com/bwall/HashPump/pull/25
  patch :DATA

  def python3
    "python3.11"
  end

  def install
    bin.mkpath
    system "make", "INSTALLLOCATION=#{bin}",
                   "CXX=#{ENV.cxx}",
                   "install"

    system python3, *Language::Python.setup_install_args(prefix, python3)
  end

  test do
    output = shell_output("#{bin}/hashpump -s '6d5f807e23db210bc254a28be2d6759a0f5f5d99' " \
                          "-d 'count=10&lat=37.351&user_id=1&long=-119.827&waffle=eggo' " \
                          "-a '&waffle=liege' -k 14")
    assert_match "0e41270260895979317fff3898ab85668953aaa2", output
    assert_match "&waffle=liege", output
    assert_equal 0, $CHILD_STATUS.exitstatus

    (testpath/"test.py").write <<~EOS
      import hashpumpy
      print(hashpumpy.hashpump('ffffffff', 'original_data', 'data_to_add', len('KEYKEYKEY'))[0])
    EOS
    assert_equal "e3c4a05f", shell_output("#{python3} test.py").chomp
  end
end

__END__
diff --git a/hashpumpy.cpp b/hashpumpy.cpp
index e84e442..eaa9f04 100644
--- a/hashpumpy.cpp
+++ b/hashpumpy.cpp
@@ -1,3 +1,4 @@
+#define PY_SSIZE_T_CLEAN
 #include <Python.h>
 #include <sstream>
 #include <iomanip>
