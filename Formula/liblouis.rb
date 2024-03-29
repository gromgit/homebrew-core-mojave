class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.23.0/liblouis-3.23.0.tar.gz"
  sha256 "706fa0888a530f3c16b55c6ce0f085b25472c7f4e7047400f9df07cffbc71cfb"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/liblouis"
    sha256 mojave: "40ab32e671bde22dabc2170d7058ec341c0a82b164d102d80fe3d72678f72178"
  end

  head do
    url "https://github.com/liblouis/liblouis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
    python3 = "python3.10"
    cd "python" do
      system python3, *Language::Python.setup_install_args(prefix, python3)
    end
    mkdir "#{prefix}/tools"
    mv "#{bin}/lou_maketable", "#{prefix}/tools/", force: true
    mv "#{bin}/lou_maketable.d", "#{prefix}/tools/", force: true
  end

  test do
    o, = Open3.capture2(bin/"lou_translate", "unicode.dis,en-us-g2.ctb", stdin_data: "42")
    assert_equal o, "⠼⠙⠃"
  end
end
