class CaCertificates < Formula
  desc "Mozilla CA certificate store"
  homepage "https://curl.se/docs/caextract.html"
  url "https://curl.se/ca/cacert-2023-01-10.pem"
  sha256 "fb1ecd641d0a02c01bc9036d513cb658bbda62a75e246bedbc01764560a639f0"
  license "MPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?cacert[._-](\d{4}-\d{2}-\d{2})\.pem/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "11fe9d0a98a2ac454fa1db95762a697c3340f46560ff27e5e9db8fdeb003f17e"
  end

  def install
    pkgshare.install "cacert-#{version}.pem" => "cacert.pem"
  end

  def post_install
    if OS.mac?
      macos_post_install
    else
      linux_post_install
    end
  end

  def macos_post_install
    ohai "Regenerating CA certificate bundle from keychain, this may take a while..."

    keychains = %w[
      /Library/Keychains/System.keychain
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]

    certs_list = Utils.safe_popen_read("/usr/bin/security", "find-certificate", "-a", "-p", *keychains)
    certs = certs_list.scan(
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m,
    )

    # Check that the certificate has not expired
    valid_certs = certs.select do |cert|
      begin
        Utils.safe_popen_write("/usr/bin/openssl", "x509", "-inform", "pem",
                                                           "-checkend", "0",
                                                           "-noout") do |openssl_io|
          openssl_io.write(cert)
        end
      rescue ErrorDuringExecution
        # Expired likely.
        next
      end

      # Only include certs that have are designed to act as a SSL root.
      purpose = Utils.safe_popen_write("/usr/bin/openssl", "x509", "-inform", "pem",
                                                                   "-purpose",
                                                                   "-noout") do |openssl_io|
        openssl_io.write(cert)
      end
      purpose.include?("SSL server CA : Yes")
    end

    # Check that the certificate is trusted in keychain
    trusted_certs = begin
      tmpfile = Tempfile.new

      verify_args = %W[
        -l -L
        -c #{tmpfile.path}
        -p ssl
      ]
      on_high_sierra :or_newer do
        verify_args << "-R" << "offline"
      end

      valid_certs.select do |cert|
        tmpfile.rewind
        tmpfile.write cert
        tmpfile.truncate cert.size
        tmpfile.flush
        Utils.safe_popen_read("/usr/bin/security", "verify-cert", *verify_args)
        true
      rescue ErrorDuringExecution
        # Invalid.
        false
      end
    ensure
      tmpfile&.close!
    end

    # Get SHA256 fingerprints for all trusted certs
    fingerprints = trusted_certs.to_set do |cert|
      Utils.safe_popen_write("/usr/bin/openssl", "x509", "-inform", "pem",
                                                         "-fingerprint",
                                                         "-sha256",
                                                         "-noout") do |openssl_io|
        openssl_io.write(cert)
      end
    end

    # Now process Mozilla certs we downloaded.
    pem_certs_list = File.read(pkgshare/"cacert.pem")
    pem_certs = pem_certs_list.scan(
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m,
    )

    # Append anything new.
    trusted_certs += pem_certs.select do |cert|
      fingerprint = Utils.safe_popen_write("/usr/bin/openssl", "x509", "-inform", "pem",
                                                                       "-fingerprint",
                                                                       "-sha256",
                                                                       "-noout") do |openssl_io|
        openssl_io.write(cert)
      end
      fingerprints.add?(fingerprint)
    end

    pkgetc.mkpath
    (pkgetc/"cert.pem").atomic_write(trusted_certs.join("\n") << "\n")
  end

  def linux_post_install
    rm_f pkgetc/"cert.pem"
    pkgetc.mkpath
    cp pkgshare/"cacert.pem", pkgetc/"cert.pem"
  end

  test do
    assert_path_exists pkgshare/"cacert.pem"
    assert_path_exists pkgetc/"cert.pem"
    assert compare_file(pkgshare/"cacert.pem", pkgetc/"cert.pem") if OS.linux?
  end
end
