class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA"
  homepage "https://github.com/OpenVPN/easy-rsa"
  url "https://github.com/OpenVPN/easy-rsa/archive/v3.1.0.tar.gz"
  sha256 "5fdb3586987695ae7746a64b08bf1d2daf1e63c72a2ee64ec973ad230d0f6edb"
  license "GPL-2.0-only"
  head "https://github.com/OpenVPN/easy-rsa.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/easy-rsa"
    sha256 cellar: :any_skip_relocation, mojave: "09a549d3ff88f28ee642dcf3ba74905be122769882ce16256f133d48e8e0d5ca"
  end

  depends_on "openssl@3"

  def install
    inreplace "easyrsa3/easyrsa", "'/etc/easy-rsa'", "'#{pkgetc}'"
    libexec.install "easyrsa3/easyrsa"
    (bin/"easyrsa").write_env_script libexec/"easyrsa",
      EASYRSA:         pkgetc,
      EASYRSA_OPENSSL: Formula["openssl@3"].opt_bin/"openssl",
      EASYRSA_PKI:     "${EASYRSA_PKI:-#{etc}/pki}"

    pkgetc.install %w[
      easyrsa3/openssl-easyrsa.cnf
      easyrsa3/x509-types
      easyrsa3/vars.example
    ]

    doc.install %w[
      ChangeLog
      COPYING.md
      KNOWN_ISSUES
      README.md
      README.quickstart.md
    ]

    doc.install Dir["doc/*"]
  end

  def caveats
    <<~EOS
      By default, keys will be created in:
        #{etc}/pki

      The configuration may be modified by editing and renaming:
        #{pkgetc}/vars.example
    EOS
  end

  test do
    ENV["EASYRSA_PKI"] = testpath/"pki"
    assert_match "init-pki complete", shell_output("easyrsa init-pki")
  end
end
