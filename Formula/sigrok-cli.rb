class SigrokCli < Formula
  desc "Sigrok command-line interface to use logic analyzers and more"
  homepage "https://sigrok.org/"
  url "https://sigrok.org/download/source/sigrok-cli/sigrok-cli-0.7.2.tar.gz"
  sha256 "71d0443f36897bf565732dec206830dbea0f2789b6601cf10536b286d1140ab8"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://sigrok.org/wiki/Downloads"
    regex(/href=.*?sigrok-cli[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  head do
    url "git://sigrok.org/sigrok-cli", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsigrok"
  depends_on "libsigrokdecode"

  def install
    system "./autogen.sh" if build.head?
    mkdir "build" do
      system "../configure", *std_configure_args
      system "make", "install"
    end
  end

  test do
    # Make sure that we can capture samples from the demo device
    system "#{bin}/sigrok-cli", "-d", "demo", "--samples", "1"
  end
end
