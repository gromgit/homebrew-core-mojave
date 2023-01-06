class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.20/fossil-src-2.20.tar.gz"
  sha256 "0892ea4faa573701ca285a3d4a2d203e8abbb022affe3b1be35658845e8de721"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fossil"
    sha256 cellar: :any, mojave: "da3dbdc5b112d5a4ccbb9843811b4bda351dad373dc6ee62ce053f01c9bc09b1"
  end

  depends_on "openssl@3"
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
    bash_completion.install "tools/fossil-autocomplete.bash"
    zsh_completion.install "tools/fossil-autocomplete.zsh" => "_fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
