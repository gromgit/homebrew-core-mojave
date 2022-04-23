class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "https://calcurse.org/"
  url "https://calcurse.org/files/calcurse-4.8.0.tar.gz"
  sha256 "48a736666cc4b6b53012d73b3aa70152c18b41e6c7b4807fab0f168d645ae32c"
  license "BSD-2-Clause"

  livecheck do
    url "https://calcurse.org/downloads/"
    regex(/href=.*?calcurse[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/calcurse"
    sha256 mojave: "16d1dc1aef7191ccdf4a4dcf9898e73d83ad4d63f9e4db76c4b7cf09cd3be172"
  end

  head do
    url "https://git.calcurse.org/calcurse.git"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "gettext"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Specify XML_CATALOG_FILES for asciidoc
    system "make", "XML_CATALOG_FILES=/usr/local/etc/xml/catalog"
    system "make", "install"
  end

  test do
    system bin/"calcurse", "-v"
  end
end
