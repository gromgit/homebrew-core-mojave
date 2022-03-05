class FuzzyFind < Formula
  desc "Fuzzy filename finder matching across directories as well as files"
  homepage "https://github.com/silentbicycle/ff"
  url "https://github.com/silentbicycle/ff/archive/v0.6-flag-features.tar.gz"
  version "0.6.0"
  sha256 "104300ba16af18d60ef3c11d70d2ec2a95ddf38632d08e4f99644050db6035cb"
  head "https://github.com/silentbicycle/ff.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)/i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fuzzy-find"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "88014df2dbf689f62a24db1e0c82fcbcc0a8a2680956f05cb8a4304089469a01"
  end

  # This regex intentionally allows anything to come after the numeric version
  # (instead of using $ at the end like we normally do). These tags have a
  # format like `0.6-flag-features` or `v0.5-first-form`, where the trailing
  # text seems to be a release name. This regex may become a problem in the
  # future if we encounter releases like `1.2-alpha1` `1.2-rc1`, etc.

  def install
    system "make"
    bin.install "ff"
    man1.install "ff.1"
    elisp.install "fuzzy-find.el"
  end

  test do
    system bin/"ff", "-t"
  end
end
