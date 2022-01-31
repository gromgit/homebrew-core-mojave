class AescryptPacketizer < Formula
  desc "Encrypt and decrypt using 256-bit AES encryption"
  homepage "https://www.aescrypt.com"
  url "https://www.aescrypt.com/download/v3/linux/aescrypt-3.15.tgz"
  sha256 "263c0abd1da22d8cffd181a2d99c6d90410e5c2c6deeb1d6286f01b08a2f6763"

  livecheck do
    url "https://www.aescrypt.com/download/"
    regex(%r{href=.*?/linux/aescrypt[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aescrypt-packetizer"
    sha256 cellar: :any_skip_relocation, mojave: "b71d482a578bf8cda59f6e3579d6ec3def2fed36381ceb605779f8fdbb484b6f"
  end

  head do
    url "https://github.com/paulej/AESCrypt.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on xcode: :build

  def install
    if build.head?
      cd "linux"
      system "autoreconf", "-ivf"

      args = %W[
        prefix=#{prefix}
        --disable-gui
      ]
      args << "--enable-iconv" if OS.mac?

      system "./configure", *args
      system "make", "install"
    else
      cd "src" do
        system "make"

        bin.install "aescrypt"
        bin.install "aescrypt_keygen"
      end
      man1.install "man/aescrypt.1"
    end

    # To prevent conflict with our other aescrypt, rename the binaries.
    mv "#{bin}/aescrypt", "#{bin}/paescrypt"
    mv "#{bin}/aescrypt_keygen", "#{bin}/paescrypt_keygen"
  end

  def caveats
    <<~EOS
      To avoid conflicting with our other AESCrypt package the binaries
      have been renamed paescrypt and paescrypt_keygen.
    EOS
  end

  test do
    path = testpath/"secret.txt"
    original_contents = "What grows when it eats, but dies when it drinks?"
    path.write original_contents

    system bin/"paescrypt", "-e", "-p", "fire", path
    assert_predicate testpath/"#{path}.aes", :exist?

    system bin/"paescrypt", "-d", "-p", "fire", "#{path}.aes"
    assert_equal original_contents, path.read
  end
end
