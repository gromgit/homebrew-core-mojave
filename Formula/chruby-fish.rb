class ChrubyFish < Formula
  desc "Thin wrapper around chruby to make it work with the Fish shell"
  homepage "https://github.com/JeanMertz/chruby-fish#readme"
  url "https://github.com/JeanMertz/chruby-fish/archive/v1.0.0.tar.gz"
  sha256 "db1023255fa55c9a01b06404cd394cccf790d42985cf85706211e5a0dda4fd9f"
  license "MIT"
  head "https://github.com/JeanMertz/chruby-fish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "24e950289cce73bdbb91af11cfadcbb09118902d48968213d036dc9a5c2dcb31"
  end

  depends_on "chruby"
  depends_on "fish"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "chruby: #{version}", shell_output("fish -c '. #{share}/fish/vendor_functions.d/chruby.fish; chruby --version'")
  end
end
