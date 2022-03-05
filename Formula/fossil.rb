class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.18/fossil-src-2.18.tar.gz"
  sha256 "300c1d5cdd6224ec6e8c88ab3f38d50f80e4071b503731b75bd61274cf310733"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fossil"
    rebuild 1
    sha256 cellar: :any, mojave: "decfd7122397184c8bcb8da41a67ba88b34264c0448f519f32e98fc42986adc8"
  end

  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
      "--json",
      "--disable-fusefs",
    ]

    args << if MacOS.sdk_path_if_needed
      "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
