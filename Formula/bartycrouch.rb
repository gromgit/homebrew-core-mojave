class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git",
      tag:      "4.0.2",
      revision: "7d4cfec9530c7364727a4461712b54909f8d4a90"
  head "https://github.com/Flinesoft/BartyCrouch.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bartycrouch"
    sha256 cellar: :any_skip_relocation, mojave: "1133c4b25f7e0d730cdaf2470188b8d383db7c6cd4d82ce6d0d720f4b5acb2b9"
  end

  depends_on xcode: ["10.2", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  def caveats
    <<~EOS
      IMPORTANT: This is the final version of #{name} that's compatible with Mojave.
    EOS
  end

  test do
    (testpath/"Test.swift").write <<~EOS
      import Foundation

      class Test {
        func test() {
            NSLocalizedString("test", comment: "")
        }
      }
    EOS

    (testpath/"en.lproj/Localizable.strings").write <<~EOS
      /* No comment provided by engineer. */
      "oldKey" = "Some translation";
    EOS

    system bin/"bartycrouch", "update"
    assert_match(/"oldKey" = "/, File.read("en.lproj/Localizable.strings"))
    assert_match(/"test" = "/, File.read("en.lproj/Localizable.strings"))
  end
end
