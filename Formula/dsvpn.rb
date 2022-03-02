class Dsvpn < Formula
  desc "Dead Simple VPN"
  homepage "https://github.com/jedisct1/dsvpn"
  url "https://github.com/jedisct1/dsvpn/archive/0.1.4.tar.gz"
  sha256 "b98604e1ca2ffa7a909bf07ca7cf0597e3baa73c116fbd257f93a4249ac9c0c5"
  license "MIT"
  head "https://github.com/jedisct1/dsvpn.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dsvpn"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "44cce830ec6784680a1a5e3138d6b1b4faa1f578bbffad1f133fd145f0fa86a4"
  end


  def install
    sbin.mkpath
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      dsvpn requires root privileges so you will need to run `sudo #{HOMEBREW_PREFIX}/sbin/dsvpn`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    expected = if OS.mac?
      "tun device creation: Operation not permitted"
    else
      "Unable to automatically determine the gateway IP"
    end
    assert_match expected, shell_output("#{sbin}/dsvpn client /dev/zero 127.0.0.1 0 2>&1", 1)
  end
end
