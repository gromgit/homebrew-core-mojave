class Streamlink < Formula
  include Language::Python::Virtualenv

  desc "CLI for extracting streams from various websites to a video player"
  homepage "https://streamlink.github.io/"
  url "https://files.pythonhosted.org/packages/31/c8/dd8c1cfff095b39d42c2bcd72cba95983e43001d51928cd9d2874e81eb37/streamlink-4.2.0.tar.gz"
  sha256 "8e745c4b91f1cc3789c619ac8dadbd461c10a66a73b70453e1d5dfa03f5bd6e4"
  license "BSD-2-Clause"
  head "https://github.com/streamlink/streamlink.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/streamlink"
    sha256 cellar: :any, mojave: "1074f26e485d6026ef0b12a96651d0565e2d3f4af314164225dd14d0968dbeee"
  end

  depends_on "libxml2" # https://github.com/Homebrew/homebrew-core/issues/98468
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "pycountry" do
    url "https://files.pythonhosted.org/packages/33/24/033604d30f6cf82d661c0f9dfc2c71d52cafc2de516616f80d3b0600cb7c/pycountry-22.3.5.tar.gz"
    sha256 "b2163a246c585894d808f18783e19137cb70a0c18fb36748dc01fc6f109c1646"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/11/e4/a8e8056a59c39f8c9ddd11d3bc3e1a67493abe746df727e531f66ecede9e/pycryptodome-3.15.0.tar.gz"
    sha256 "9135dddad504592bcc18b0d2d95ce86c3a5ea87ec6447ef25cfedea12d6018b8"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/25/36/f056e5f1389004cf886bb7a8514077f24224238a7534497c014a6b9ac770/urllib3-1.26.10.tar.gz"
    sha256 "879ba4d1e89654d9769ce13121e0f94310ea32e8d2f8cf587b77c08bbcdb30d6"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/0e/e7/e705ead133d21de4be752af4b3a0cb1f02514ff45bf165b3955c1ce22077/websocket-client-1.3.3.tar.gz"
    sha256 "d58c5f284d6a9bf8379dab423259fe8f85b70d5fa5d2916d5791a84594b122b1"
  end

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/streamlink.1"
  end

  test do
    system "#{bin}/streamlink", "https://vimeo.com/189776460", "360p", "-o", "video.mp4"
    assert_match "video.mp4: ISO Media, MP4 v2", shell_output("file video.mp4")
    output = shell_output("#{bin}/streamlink -l debug 'https://ok.ru/video/3388934659879'")
    assert_match "Available streams:", output
    refute_match "error", output
    refute_match "Could not find metadata", output
  end
end
