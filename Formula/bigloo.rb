class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo-4.4c-4.tar.gz"
  version "4.4c-4"
  sha256 "4ed71a86c6d762c35352e9f04871a11fe90fa5dbc974e728a86d9e8229d7c70f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www-sop.inria.fr/indes/fp/Bigloo/download.html"
    regex(/bigloo-latest\.t.+?\(([^)]+?)\)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bigloo"
    sha256 mojave: "5b9890ca823e3615927605ceaa2216d8e040c235ebf6092c964246796135c913"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libunistring"
  depends_on "libuv"
  depends_on "openjdk"
  depends_on "openssl@1.1"
  depends_on "pcre2"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # Force bigloo not to use vendored libraries
    inreplace "configure", /(^\s+custom\w+)=yes$/, "\\1=no"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man1}
      --infodir=#{info}
      --customgc=no
      --customgmp=no
      --customlibuv=no
      --customunistring=no
      --native=yes
      --disable-mpg123
      --disable-flac
      --jvm=yes
    ]

    if OS.mac?
      args += %w[
        --os-macosx
        --disable-alsa
      ]
    end

    system "./configure", *args

    system "make"
    system "make", "install"

    # Install the other manpages too
    manpages = %w[bgldepend bglmake bglpp bgltags bglafile bgljfile bglmco bglprof]
    manpages.each { |m| man1.install "manuals/#{m}.man" => "#{m}.1" }
  end

  test do
    program = <<~EOS
      (display "Hello World!")
      (newline)
      (exit)
    EOS
    assert_match "Hello World!\n", pipe_output("#{bin}/bigloo -i -", program)
  end
end
