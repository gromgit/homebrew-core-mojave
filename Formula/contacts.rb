# Use a sha1 instead of a tag, as the author has not provided a tag for
# this release. In fact, the author no longer uses this software, so it
# is a candidate for removal if no new maintainer is found.
class Contacts < Formula
  desc "Command-line tool to access macOS's Contacts (formerly 'Address Book')"
  homepage "https://web.archive.org/web/20181108222900/gnufoo.org/contacts/contacts.html"
  url "https://github.com/dhess/contacts/archive/4092a3c6615d7a22852a3bafc44e4aeeb698aa8f.tar.gz"
  version "1.1a-3"
  sha256 "e3dd7e592af0016b28e9215d8ac0fe1a94c360eca5bfbdafc2b0e5d76c60b871"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "02f0086162efb3e8473f846252a6c4813e85a1bbf57a38e3420f20946eafa60f"
    sha256 cellar: :any_skip_relocation, mojave:      "ad45d22cee04997d286b7e07f19328cd59dcb3a335a6a93e5ed24a8b995080f1"
    sha256 cellar: :any_skip_relocation, high_sierra: "27b7b256aa6f034b245c6cc1e6c7def038bbf183e73f94db942a220aa876ef0d"
    sha256 cellar: :any_skip_relocation, sierra:      "21bf2ec23b9f096ed09acd44dbd7c2cc59891c01a821a6695e58d69c54647c0e"
    sha256 cellar: :any_skip_relocation, el_capitan:  "7f6c6817310dacf83041d2017e8841b49e26df0d09039692576b6fe0fed52ecc"
  end

  disable! date: "2020-12-08", because: :unmaintained

  depends_on xcode: :build

  def install
    system "make", "SDKROOT=#{MacOS.sdk_path}"
    bin.install "build/Deployment/contacts"
    man1.install gzip("contacts.1")
  end

  test do
    output = shell_output("#{bin}/contacts -h 2>&1", 2)
    assert_match "displays contacts from the AddressBook database", output
  end
end
