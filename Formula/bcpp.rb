class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "https://invisible-island.net/bcpp/"
  url "https://invisible-mirror.net/archives/bcpp/bcpp-20221002.tgz"
  sha256 "ad87caf9f1df0212994ca6eff1c4e0e7b63559aaef0a4ba54555092ebc438437"
  license "MIT"

  livecheck do
    url "https://invisible-island.net/bcpp/CHANGES.html"
    regex(/id=.*?t(\d{6,8})["' >]/im)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bcpp"
    sha256 cellar: :any_skip_relocation, mojave: "0bc7de4c155a3cd4d24243ce7e0c0479efcc76a6e93b157d0ddae6aff47133c0"
  end

  fails_with gcc: "5"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    etc.install "bcpp.cfg"
  end

  test do
    (testpath/"test.txt").write <<~EOS
          test
             test
      test
            test
    EOS
    system bin/"bcpp", "test.txt", "-fnc", "#{etc}/bcpp.cfg"
    assert_predicate testpath/"test.txt.orig", :exist?
    assert_predicate testpath/"test.txt", :exist?
  end
end
