class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://files.pythonhosted.org/packages/68/03/a4834a40d95a0bc2debdbad7e0e1bf909a95ff68c0a64098ea52f6ccb794/folderify-2.3.1.tar.gz"
  sha256 "0927c9453dc8efb6ea4addb0eee2711528152045f22d411c9de1e7f45621f06c"
  license "MIT"
  revision 1
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 mojave: "f27baf8ae2f171b8f7236ee399bb9df7da423c4ef81b68d7e0ece78df850d204" # fake mojave
  end

  depends_on xcode: :build
  depends_on "imagemagick"
  depends_on :macos
  depends_on "python@3.10"

  resource "osxiconutils" do
    url "https://github.com/sveinbjornt/osxiconutils.git",
        revision: "d3b43f1dd5e1e8ff60d2dbb4df4e872388d2cd10"
  end

  def install
    venv = virtualenv_create(libexec, "python3", system_site_packages: false)
    venv.pip_install_and_link buildpath

    # Replace bundled pre-built `seticon` with one we built ourselves.
    resource("osxiconutils").stage do
      xcodebuild "-arch", Hardware::CPU.arch,
                 "-parallelizeTargets",
                 "-project", "osxiconutils.xcodeproj",
                 "-target", "seticon",
                 "-configuration", "Release",
                 "CONFIGURATION_BUILD_DIR=build",
                 "SYMROOT=."

      (libexec/Language::Python.site_packages("python3")/"folderify/lib").install "build/seticon"
    end
  end

  test do
    # Copies an example icon
    site_packages = libexec/Language::Python.site_packages(Formula["python@3.10"].opt_bin/"python3")
    cp(
      "#{site_packages}/folderify/GenericFolderIcon.Yosemite.iconset/icon_16x16.png",
      "icon.png",
    )
    # folderify applies the test icon to a folder
    system "folderify", "icon.png", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath / "Icon\r", :exist?
  end
end
