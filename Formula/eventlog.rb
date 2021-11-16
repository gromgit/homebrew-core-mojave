class Eventlog < Formula
  desc "Replacement for syslog API providing structure to messages"
  homepage "https://my.balabit.com/downloads/eventlog/"
  url "https://my.balabit.com/downloads/syslog-ng/sources/3.4.3/source/eventlog_0.2.13.tar.gz"
  mirror "https://src.fedoraproject.org/lookaside/extras/eventlog/eventlog_0.2.13.tar.gz/68ec8d1ea3b98fa35002bb756227c315/eventlog_0.2.13.tar.gz"
  sha256 "7cb4e6f316daede4fa54547371d5c986395177c12dbdec74a66298e684ac8b85"

  bottle do
    sha256 cellar: :any, catalina:    "1079bd68cd23354b25d7fc014a9e20e6c522b613de1106cd8e929c708c57512b"
    sha256 cellar: :any, mojave:      "7b9117f49ce6fa552bbea8cd7e189c4ec1d9123d81ac5d459d4ca4f57331e429"
    sha256 cellar: :any, high_sierra: "be5272b1fb50fb84ba175d4acdbe0632d46444df4e93fb913a9e3ee3ba2d6d33"
    sha256 cellar: :any, sierra:      "266c920dec2b898e620a5de1bdcbcc68c3b06663c8b4f8d155138ba989958b99"
    sha256 cellar: :any, el_capitan:  "9073fb11ae9c20375295c36b5bb6845639ea1f9c17a677c1d93ff206075ff871"
    sha256 cellar: :any, yosemite:    "2bdc1f762ea05e79f486e7e78b8a173ea99a5a76b4bedd28a03a1c8912f39925"
  end

  disable! date: "2020-12-08", because: :unmaintained

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
