class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v21.2.tar.gz"
  sha256 "dec6ba261b423ea08e3a62a146ffd5db2b49a0b954a37fc37b24b35da2f7f773"
  license all_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://github.com/cjdelisle/cjdns.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cjdns"
    sha256 cellar: :any_skip_relocation, mojave: "736b9f6de1102940a645e56ba4075f2c769273f1a2f1f41d36e89c47c7c9c726"
  end


  depends_on "node" => :build
  depends_on "rust" => :build

  def install
    # Avoid using -march=native
    inreplace "node_build/make.js",
              "var NO_MARCH_FLAG = ['arm', 'ppc', 'ppc64'];",
              "var NO_MARCH_FLAG = ['x64', 'arm', 'arm64', 'ppc', 'ppc64'];"

    system "./do"
    bins = %w[cjdroute makekeys privatetopublic publictoip6 randombytes sybilsim]
    bin.install(*bins)

    # Avoid conflict with mkpasswd from `expect`
    bin.install "mkpasswd" => "cjdmkpasswd"

    man1.install "doc/man/cjdroute.1"
    man5.install "doc/man/cjdroute.conf.5"
  end

  test do
    sample_conf = JSON.parse(shell_output("#{bin}/cjdroute --genconf"))
    sample_private_key = sample_conf["privateKey"]
    sample_public_key = sample_conf["publicKey"]
    sample_ipv6 = IPAddr.new(sample_conf["ipv6"]).to_s

    expected_output = <<~EOS
      Input privkey: #{sample_private_key}
      Matching pubkey: #{sample_public_key}
      Resulting address: #{sample_ipv6}
    EOS

    assert_equal expected_output, pipe_output(bin/"privatetopublic", sample_private_key)
  end
end
