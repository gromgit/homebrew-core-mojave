class Libvbucket < Formula
  desc "Utility library providing mapping to virtual buckets"
  homepage "https://couchbase.com/develop/c/current"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libvbucket-1.8.0.4.tar.gz"
  sha256 "398ba491d434fc109fd64f38678916e1aa19c522abc8c090dbe4e74a2a2ea38d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, catalina:    "3bad5f5bc0f7644ba2960c330016dd350ffe386620642c4fbb34dbbda840e36a"
    sha256 cellar: :any, mojave:      "99703e4bfe795310481070096dd496b41185cdde224aa2381a2a7b2dcc618278"
    sha256 cellar: :any, high_sierra: "bce41a629d7cf6504a1d5fa518d31cc46fcc93b8c82187167d4ab9306f2d593d"
    sha256 cellar: :any, sierra:      "69c96d5758926202939b79930d82da27bd65d50e0ef19d844ac705cacd99ba58"
    sha256 cellar: :any, el_capitan:  "cc3333f73161a96deb410ae0b8185a74e0c2a5bc8e62018929b17efe6ef732b8"
    sha256 cellar: :any, yosemite:    "dd69ae3261c461b15bd29e435ab95496441dfde4535cb7d6925527cdfa8c64dd"
  end

  disable! date: "2020-12-08", because: :unmaintained

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-docs"
    system "make", "install"
  end

  test do
    json = JSON.generate(
      "hashAlgorithm" => "CRC",
      "numReplicas"   => 2,
      "serverList"    => ["server1:11211", "server2:11210", "server3:11211"],
      "vBucketMap"    => [[0, 1, 2], [1, 2, 0], [2, 1, -1], [1, 2, 0]],
    )

    expected = <<~EOS
      key: hello master: server1:11211 vBucketId: 0 couchApiBase: (null) replicas: server2:11210 server3:11211
      key: world master: server2:11210 vBucketId: 3 couchApiBase: (null) replicas: server3:11211 server1:11211
    EOS

    output = pipe_output("#{bin}/vbuckettool - hello world", json)
    assert_equal expected, output
  end
end
