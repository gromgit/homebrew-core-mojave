class Esptool < Formula
  include Language::Python::Virtualenv

  desc "ESP8266 and ESP32 serial bootloader utility"
  homepage "https://github.com/espressif/esptool"
  url "https://files.pythonhosted.org/packages/c9/b1/ec839625ba096b8a1ce4ea3c86da5a72a5be8686147c52ba52f863c65156/esptool-4.0.1.tar.gz"
  sha256 "feeab030fe781e43cbbd5641f23766e52e7d4665b4e221fbf6155dd3d80f0b55"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/esptool"
    sha256 cellar: :any, mojave: "df6fd31a9338776616c31a22f07621fc5b8f147b652c3bf36cb0ea33ae26377b"
  end

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/4c/b1/80d58eeb21c9d4ca739770558d61f6adacb13aa4908f4f55e0974cbd25ee/bitstring-3.1.9.tar.gz"
    sha256 "a5848a3f63111785224dca8bb4c0a75b62ecdef56a042c8d6be74b16f7e860e7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/51/05/bb2b681f6a77276fc423d04187c39dafdb65b799c8d87b62ca82659f9ead/cryptography-37.0.2.tar.gz"
    sha256 "f224ad253cc9cea7568f49077007d2263efa57396a2f2f78114066fd54b5c68e"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/bf/3d/3d909532ad541651390bf1321e097404cbd39d1d89c2046f42a460220fb3/ecdsa-0.17.0.tar.gz"
    sha256 "b9f500bb439e4153d0330610f5d26baaf18d17b8ced1bc54410d189385ea68aa"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "reedsolo" do
    url "https://files.pythonhosted.org/packages/c8/cb/bb2ddbd00c9b4215dd57a2abf7042b0ae222b44522c5eb664a8fd9d786da/reedsolo-1.5.4.tar.gz"
    sha256 "b8b25cdc83478ccb06361a0e8fadc27b376a3dfabbb1dc6bb583a998a22c0127"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "base64"

    assert_match version.to_s, shell_output("#{bin}/esptool.py version")
    assert_match "usage: espefuse.py", shell_output("#{bin}/espefuse.py --help")
    assert_match version.to_s, shell_output("#{bin}/espsecure.py --help")

    (testpath/"helloworld-esp8266.bin").write ::Base64.decode64 <<~EOS
      6QIAICyAEEAAgBBAMAAAAFDDAAAAgP4/zC4AQMwkAEAh/P8SwfAJMQH8/8AAACH5/wH6/8AAAAb//wAABvj/AACA/j8QAAAASGVsbG8gd29ybGQhCgAAAAAAAAAAAAAD
    EOS

    result = shell_output("#{bin}/esptool.py --chip esp8266 image_info #{testpath}/helloworld-esp8266.bin")
    assert_match "4010802c", result
  end
end
