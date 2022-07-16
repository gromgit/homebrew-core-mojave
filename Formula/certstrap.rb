class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap/archive/v1.3.0.tar.gz"
  sha256 "4b32289c20dfad7bf8ab653c200954b3b9981fcbf101b699ceb575c6e7661a90"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/certstrap"
    sha256 cellar: :any_skip_relocation, mojave: "ce3c7847674ad469c1d88fc1056c3382522d763cb816573d73e54a46f85de737"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"certstrap"
    prefix.install_metafiles
  end

  test do
    system "#{bin}/certstrap", "init", "--common-name", "Homebrew Test CA", "--passphrase", "beerformyhorses"
  end
end
