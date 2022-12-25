class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap/archive/v1.3.0.tar.gz"
  sha256 "4b32289c20dfad7bf8ab653c200954b3b9981fcbf101b699ceb575c6e7661a90"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/certstrap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "9b35ca6b0edab6838f1a9ebe0480174a9a1b0446f7c7bbf2a5239c41d166b27c"
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
