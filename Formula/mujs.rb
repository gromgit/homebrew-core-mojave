class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      tag:      "1.2.0",
      revision: "dd0a0972b4428771e6a3887da2210c7c9dd40f9c"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mujs"
    sha256 cellar: :any, mojave: "24526625ae6a7140567619902536df2a9d9e207dbf5484410abd549a0bdda754"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "release"
    system "make", "prefix=#{prefix}", "install"
    system "make", "prefix=#{prefix}", "install-shared"
  end

  test do
    (testpath/"test.js").write <<~EOS
      print('hello, world'.split().reduce(function (sum, char) {
        return sum + char.charCodeAt(0);
      }, 0));
    EOS
    assert_equal "104", shell_output("#{bin}/mujs test.js").chomp
  end
end
