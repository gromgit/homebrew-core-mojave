class Grepcidr < Formula
  desc "Filter IP addresses matching IPv4 CIDR/network specification"
  homepage "http://www.pc-tools.net/unix/grepcidr/"
  url "http://www.pc-tools.net/files/unix/grepcidr-2.0.tar.gz"
  sha256 "61886a377dabf98797145c31f6ba95e6837b6786e70c932324b7d6176d50f7fb"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?grepcidr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1e9fe9d6d9eeed951aa7bc502e9bea2e03f6196225d57826bf4882854c86980"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2a44c09499df8266ce513c939722e15a3b8365cb9802a1311450d470ad01b0e"
    sha256 cellar: :any_skip_relocation, monterey:       "bd5e42708f90385a347624dafd62092c377d8ae0b31d4fb244203f505f427055"
    sha256 cellar: :any_skip_relocation, big_sur:        "1aee569b691f9aee204924d4059b55b5d28be63394350b9ed5993d42a131c081"
    sha256 cellar: :any_skip_relocation, catalina:       "29222220edfad5ce8db2a197f1e0a3fe1d703a62338c5dc8d28ed8ce47afe987"
    sha256 cellar: :any_skip_relocation, mojave:         "195665f1f4647ec6ee1f43830cd21079413fc8c1df4dce5e869891d402791488"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7266be7b9262d50ab08d63529cf9858764573784ab63918010454ec2d76363b6"
    sha256 cellar: :any_skip_relocation, sierra:         "12dfa49026bffb77ed1c4a08e9b60b56859eb183bbf791754d0b1d476ba6d795"
    sha256 cellar: :any_skip_relocation, el_capitan:     "31ccf6792cab3c5022530ef4576ea53e6dedd4855b939d11212fea0d7fa294dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb0c1384a2e7e8c25c10ca2c767732ba49a4b57d7e2249ce415d11b76c4dadc0"
  end

  def install
    system "make"
    bin.install "grepcidr"
    man1.install "grepcidr.1"
  end

  test do
    (testpath/"access.log").write <<~EOS
      127.0.0.1 duck
      8.8.8.8 duck
      66.249.64.123 goose
      192.168.0.1 duck
    EOS

    output = shell_output("#{bin}/grepcidr 66.249.64.0/19 access.log")
    assert_equal "66.249.64.123 goose", output.strip
  end
end
