class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20221020.tar_0.gz"
  # Work around invalid tarball extension (.tar_0.gz). Remove when fixed.
  version "20221020"
  sha256 "33a2e394aca0ca57d4018afe3da340dfad5eb45b1b9300e81dd595fda07cf1c5"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/href=.*?acpica-unix[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/acpica"
    sha256 cellar: :any_skip_relocation, mojave: "e627ed5e4a5dc68f33424344ddbe74d24e50eeb96d80b644e707f346ebf79891"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  def install
    # Work around invalid tarball extension (.tar_0.gz). Remove when fixed.
    system "tar", "--strip-components=1", "-xf", "acpica-unix-#{version}.tar_0"
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
