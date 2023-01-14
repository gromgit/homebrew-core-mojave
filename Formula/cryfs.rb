class Cryfs < Formula
  include Language::Python::Virtualenv

  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.11.3/cryfs-0.11.3.tar.gz"
  sha256 "cffef7669b8cbec3e7420088faac492390b9e1f3d3d0dc2a245b87f8df05f190"
  license "LGPL-3.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "998aed8cbec6408a24741d7b6ca69a7f85aed5d6b4bdc66d80755aa288b5191a"
  end

  head do
    url "https://github.com/cryfs/cryfs.git", branch: "develop"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "curl"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "range-v3"
  depends_on "spdlog"

  fails_with gcc: "5"

  resource "versioneer" do
    url "https://files.pythonhosted.org/packages/15/86/bed1c929495d8ca30512c8fcc6e9c2555ecffcdd32f0c04f11e492eba9e0/versioneer-0.28.tar.gz"
    sha256 "7175ca8e7bb4dd0e3c9779dd2745e5b4a6036304af3f5e50bd896f10196586d6"
  end

  def install
    python = "python3.11"
    venv_root = buildpath/"venv"

    venv = virtualenv_create(venv_root, python)
    venv.pip_install resource("versioneer")

    ENV.prepend_path "PYTHONPATH", venv_root/Language::Python.site_packages(python)
    ENV.prepend_path "PATH", venv_root/"bin"

    configure_args = [
      "-DBUILD_TESTING=off",
    ]

    system "cmake", "-B", "build", "-S", ".", *configure_args, *std_cmake_args,
                    "-DCRYFS_UPDATE_CHECKS=OFF",
                    "-DDEPENDENCY_CONFIG=cmake-utils/DependenciesFromLocalSystem.cmake"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CRYFS_FRONTEND"] = "noninteractive"

    # Test showing help page
    assert_match "CryFS", shell_output("#{bin}/cryfs 2>&1", 10)

    # Test mounting a filesystem. This command will ultimately fail because homebrew tests
    # don't have the required permissions to mount fuse filesystems, but before that
    # it should display "Mounting filesystem". If that doesn't happen, there's something
    # wrong. For example there was an ABI incompatibility issue between the crypto++ version
    # the cryfs bottle was compiled with and the crypto++ library installed by homebrew to.
    mkdir "basedir"
    mkdir "mountdir"
    expected_output = "fuse: device not found, try 'modprobe fuse' first"
    assert_match expected_output, pipe_output("#{bin}/cryfs -f basedir mountdir 2>&1", "password")
  end
end
