class Cryfs < Formula
  include Language::Python::Virtualenv

  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.11.2/cryfs-0.11.2.tar.gz"
  sha256 "a89ab8fea2d494b496867107ec0a3772fe606ebd71ef12152fcd233f463a2c00"
  license "LGPL-3.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "31ac11d8d0dcffe93dfab1e53b833addf0b26934cb6f5fe562fa92d63c1b74ed"
  end

  head do
    url "https://github.com/cryfs/cryfs.git", branch: "develop"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "range-v3"
  depends_on "spdlog"

  uses_from_macos "curl"

  on_macos do
    depends_on "libomp"
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "gcc"
    depends_on "libfuse@2"
  end

  fails_with gcc: "5"

  resource("versioneer") do
    url "https://files.pythonhosted.org/packages/25/ba/abbf66b15ad1c195c96d533a70ca7962ddd8e37d682b60b03e59afec4487/versioneer-0.22.tar.gz"
    sha256 "9f0e9a2cb5ef521cbfd104d43a208dd9124dfb4accfa72d694e0d0430a0142bc"
  end

  # Fix build with fmt 9+
  # https://github.com/cryfs/cryfs/pull/433
  patch do
    url "https://github.com/cryfs/cryfs/commit/01cf1d5fc98b6c9ac4d7dacb59c6fb787225ea48.patch?full_index=1"
    sha256 "1ad5022b6054e9ee98721c30cd8c038bf5f2fb5750047a954df62aefbd1ee3fd"
  end

  def install
    python = "python3.10"
    venv_root = buildpath/"venv"

    venv = virtualenv_create(venv_root, python)
    venv.pip_install resource("versioneer")

    ENV.prepend_path "PYTHONPATH", venv_root/Language::Python.site_packages(python)
    ENV.prepend_path "PATH", venv_root/"bin"

    configure_args = [
      "-DBUILD_TESTING=off",
    ]

    if build.head? && OS.mac?
      libomp = Formula["libomp"]
      configure_args.concat(
        [
          "-DOpenMP_CXX_FLAGS='-Xpreprocessor -fopenmp -I#{libomp.include}'",
          "-DOpenMP_CXX_LIB_NAMES=omp",
          "-DOpenMP_omp_LIBRARY=#{libomp.lib}/libomp.dylib",
        ],
      )
    end

    system "cmake", "-B", "build", "-S", ".", *configure_args, *std_cmake_args,
                    "-DCRYFS_UPDATE_CHECKS=OFF",
                    "-DDEPENDENCY_CONFIG=cmake-utils/DependenciesFromLocalSystem.cmake"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
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
    expected_output = OS.mac? ? "Operation not permitted" : "fuse: device not found, try 'modprobe fuse' first"
    assert_match expected_output, pipe_output("#{bin}/cryfs -f basedir mountdir 2>&1", "password")
  end
end
