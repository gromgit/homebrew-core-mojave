class Fmdiff < Formula
  desc "Use FileMerge as a diff command for Subversion and Mercurial"
  homepage "https://github.com/brunodefraine/fmscripts"
  url "https://github.com/brunodefraine/fmscripts/archive/20150915.tar.gz"
  sha256 "45ead0c972aa8ff5b3f9cf1bcefbc069931fd8218b2e28ff76958437a3fabf96"
  license :public_domain
  head "https://github.com/brunodefraine/fmscripts.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fmdiff"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "2d68e1dccbce24b6fc86ebf028ad6c4a5cfd2ef2d145ff188bd3821a72768665"
  end

  # Needs FileMerge.app, which is part of Xcode.
  depends_on :macos
  depends_on :xcode

  def install
    system "make"
    system "make", "DESTDIR=#{bin}", "install"
  end

  test do
    ENV.prepend_path "PATH", testpath

    # dummy filemerge script
    (testpath/"filemerge").write <<~EOS
      #!/bin/sh
      echo "it works"
    EOS

    chmod 0744, testpath/"filemerge"
    touch "test"

    assert_match(/it works/, shell_output("#{bin}/fmdiff test test"))
  end
end
