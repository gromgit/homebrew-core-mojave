class Swift < Formula
  include Language::Python::Shebang

  desc "High-performance system programming language"
  homepage "https://www.swift.org"
  # NOTE: Keep version in sync with resources below
  url "https://github.com/apple/swift/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
  sha256 "8cda906403c12c5bf6ba4afea14fd494b6f08354e3e43be521f52e5cc5709eb8"
  license "Apache-2.0"

  # This uses the `GithubLatest` strategy because a `-RELEASE` tag is often
  # created several days before the version is officially released.
  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/swift[._-]v?(\d+(?:\.\d+)+)[^"' >]*?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7cda451bea8fde5ac0af7be622a22a894c6b10aea23787f7e085c9ff00b3c01c"
    sha256 cellar: :any,                 arm64_monterey: "0ebba248c9898ccefa2d4b7e314a183228a829fd6df18bf7a360964c35491364"
    sha256 cellar: :any,                 arm64_big_sur:  "24f19c42284a03c33aaa6ede1d82fee8fb692e93cf84bc228ca865279d482e74"
    sha256 cellar: :any,                 ventura:        "2cf036d76c04e0dc3561ed6ae5392578083d5a238ec5007503734788ef1aa990"
    sha256 cellar: :any,                 monterey:       "4b99cef90637fa8b47ee3a45cc8dd58ebe0f4a52ef04d2981f54fda445c73d66"
    sha256 cellar: :any,                 big_sur:        "84a10d3f1750533f0df55c00d2cb065a579d4fca9ca18d65d86d9e64b93f9f5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bbec799afcc3e710667b0e610cc4518f9c3c851103d093ba27a06c44ea31808"
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Has strict requirements on the minimum version of Xcode. See _SUPPORTED_XCODE_BUILDS:
  # https://github.com/apple/swift/tree/swift-#{version}-RELEASE/utils/build-script
  # This is mostly community sourced, so may be not necessarily be accurate.
  depends_on xcode: ["13.0", :build]

  depends_on "python@3.11"

  # HACK: this should not be a test dependency but is due to a limitation with fails_with
  uses_from_macos "llvm" => [:build, :test]
  uses_from_macos "rsync" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "icu4c" # Used in swift-corelibs-foundation

    resource "swift-corelibs-foundation" do
      url "https://github.com/apple/swift-corelibs-foundation/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
      sha256 "78852bcfcf703957953761cbd18a2398c31b25f26ddf3ac18983b959e1564f3d"
    end

    resource "swift-corelibs-libdispatch" do
      url "https://github.com/apple/swift-corelibs-libdispatch/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
      sha256 "4c6b7b0ecdf10e9cbe1cd007b9a09689ea412edb8e3a289ade6d105df43209f5"

      # Fix race condition building both shared and static libdispatch.
      patch do
        url "https://github.com/Bo98/swift-corelibs-libdispatch/commit/4c5380f25706ea60e122a42879f869b2177e84b3.patch?full_index=1"
        sha256 "c3fa0ceb3a79b85f3056a45bc11564b8d32cf45767156a64f0ec1c7606910007"
      end
    end

    resource "swift-corelibs-xctest" do
      url "https://github.com/apple/swift-corelibs-xctest/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
      sha256 "4f152a62522008c09948202cd94d1d25c42b68ef5c8eb21abaa9855ea3e5a47f"
    end
  end

  # Currently requires Clang to build successfully.
  fails_with :gcc

  resource "llvm-project" do
    url "https://github.com/apple/llvm-project/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
    sha256 "003e933dcfe8251ab0d809aba36d8f38d3cafa5946df2e0f0713962d9e5ebd62"
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
    sha256 "143a58286e611460ba5ffe3d53d8be5bfbe655f9eba4571201537bb417547b63"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
    sha256 "bf1f1ca43d4f658813382ddb144d11f2ccd79ab7b10b31fde673087587310909"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
    sha256 "01ed764386cbac24c07497b192261746ddc961ce876f5f94bdcebccc1322105c"
  end

  resource "indexstore-db" do
    url "https://github.com/apple/indexstore-db/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
    sha256 "210eff2343c4b122fd8622af7f0ad19cca41838dac66db8b5a35d477eaae79a0"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/apple/sourcekit-lsp/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
    sha256 "cabcc7b5b839fff159210a04303660646ba2d1f51c9cf288c3a6df3373cbcd96"
  end

  resource "swift-driver" do
    url "https://github.com/apple/swift-driver/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
    sha256 "4a730616abd89191dfbebae888bc9c2436447868b69b2d4dcb7dbb2111ad2863"
  end

  resource "swift-tools-support-core" do
    url "https://github.com/apple/swift-tools-support-core/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
    sha256 "a0c54390f93642ee5df61bc65274c8c6a11e35177fb20188c1d9b710d69ef319"
  end

  resource "swift-docc" do
    url "https://github.com/apple/swift-docc/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
    sha256 "bd0a4e652ca15b626a30b05e6931945267c3b15a0504628a102fcc97ebed45dd"
  end

  resource "swift-lmdb" do
    url "https://github.com/apple/swift-lmdb/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
    sha256 "915c99c1b4e4031db076e3c357dedb52df350c7c968c8b77f6ad5753b11a2ff3"
  end

  resource "swift-docc-render-artifact" do
    url "https://github.com/apple/swift-docc-render-artifact/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
    sha256 "7ae5fbce5e860d94514c91f28228fb762297de2be1e01233e4046174fdfc16be"
  end

  resource "swift-docc-symbolkit" do
    url "https://github.com/apple/swift-docc-symbolkit/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
    sha256 "8a2e44c5eae188cf697785ceace4be96dceea46d47c32cb9e0728786ce72ef57"
  end

  resource "swift-markdown" do
    url "https://github.com/apple/swift-markdown/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
    sha256 "d2d14a2879d43c0579eb6e0562cb408596985862117441acf834cafa7d7f4f63"
  end

  resource "swift-cmark-gfm" do
    url "https://github.com/apple/swift-cmark/archive/refs/tags/swift-5.7.3-RELEASE-gfm.tar.gz"
    sha256 "2dbcd0fb1907b5feb321175d9a3e629dc2845a7bde7ad9e5846b3074e3d93768"
  end

  resource "swift-experimental-string-processing" do
    url "https://github.com/apple/swift-experimental-string-processing/archive/refs/tags/swift-5.7.3-RELEASE.tar.gz"
    sha256 "86f5e1c9336fc4fc7529554418bff760aaafc8397dc29c4e56a5b1334dcdffba"
  end

  # To find the version to use, check the release/#{version.major_minor} entry of:
  # https://github.com/apple/swift/blob/swift-#{version}-RELEASE/utils/update_checkout/update-checkout-config.json
  resource "swift-argument-parser" do
    url "https://github.com/apple/swift-argument-parser/archive/refs/tags/1.0.3.tar.gz"
    sha256 "a4d4c08cf280615fe6e00752ef60e28e76f07c25eb4706a9269bf38135cd9c3f"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-atomics" do
    url "https://github.com/apple/swift-atomics/archive/refs/tags/1.0.2.tar.gz"
    sha256 "c8b88186db4902dc5109340f4a745ea787cb2aa9533c7e6d1e634549f9e527b1"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-collections" do
    url "https://github.com/apple/swift-collections/archive/refs/tags/1.0.1.tar.gz"
    sha256 "575cf0f88d9068411f9acc6e3ca5d542bef1cc9e87dc5d69f7b5a1d5aec8c6b6"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-crypto" do
    url "https://github.com/apple/swift-crypto/archive/refs/tags/1.1.5.tar.gz"
    sha256 "86d6c22c9f89394fd579e967b0d5d0b6ce33cdbf52ba70f82fa313baf70c759f"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-numerics" do
    url "https://github.com/apple/swift-numerics/archive/refs/tags/1.0.1.tar.gz"
    sha256 "3ff05bb89c907d70f51dfff794ea3354a2630488925bf53382246d25089ec742"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-system" do
    url "https://github.com/apple/swift-system/archive/refs/tags/1.1.1.tar.gz"
    sha256 "865b8c380455eef27e73109835142920c60ae4c4f4178a3d12ad04acc83f1371"
  end

  # As above: refer to update-checkout-config.json
  resource "yams" do
    url "https://github.com/jpsim/Yams/archive/refs/tags/5.0.0.tar.gz"
    sha256 "b31b6df500d6191368c93f605690ca9857fff7c6fd1c8897e9765fb624535c63"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-nio" do
    url "https://github.com/apple/swift-nio/archive/refs/tags/2.31.2.tar.gz"
    sha256 "8818b8e991d36e886b207ae1023fa43c5eada7d6a1951a52ad70f7f71f57d9fe"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-nio-ssl" do
    url "https://github.com/apple/swift-nio-ssl/archive/refs/tags/2.15.0.tar.gz"
    sha256 "9ab1f0e347fad651ed5ccadc13d54c4306e6f5cd21908a4ba7d1334278a4cd55"
  end

  # Homebrew-specific patch to make the default resource directory use opt rather than Cellar.
  # This fixes output binaries from `swiftc` having a runpath pointing to the Cellar.
  # This should only be removed if an alternative solution is implemented.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5e4d9bb4d04c7c9004e95fecba362a843dc00bdd/swift/homebrew-resource-dir.diff"
    sha256 "5210ca0fd95b960d596c058f5ac76412a6987d2badf5394856bb9e31d3c68833"
  end

  def install
    workspace = buildpath.parent
    build = workspace/"build"

    install_prefix = if OS.mac?
      toolchain_prefix = "/Swift-#{version.major_minor}.xctoolchain"
      "#{toolchain_prefix}/usr"
    else
      "/libexec"
    end

    ln_sf buildpath, workspace/"swift"
    resources.each { |r| r.stage(workspace/r.name) }

    # Fix C++ header path. It wrongly assumes that it's relative to our shims.
    if OS.mac?
      inreplace workspace/"swift/utils/build-script-impl",
                "HOST_CXX_DIR=$(dirname \"${HOST_CXX}\")",
                "HOST_CXX_DIR=\"#{MacOS::Xcode.toolchain_path}/usr/bin\""
    end

    # Disable invoking SwiftPM in a sandbox while building some projects.
    # This conflicts with Homebrew's sandbox.
    helpers_using_swiftpm = [
      workspace/"indexstore-db/Utilities/build-script-helper.py",
      workspace/"sourcekit-lsp/Utilities/build-script-helper.py",
      workspace/"swift-docc/build-script-helper.py",
    ]
    inreplace helpers_using_swiftpm, "swiftpm_args = [", "\\0'--disable-sandbox',"
    inreplace workspace/"swift-docc/build-script-helper.py",
              "[swift_exec, 'package',",
              "\\0 '--disable-sandbox',"

    # Fix finding of brewed sqlite3.h.
    unless OS.mac?
      inreplace workspace/"swift-tools-support-core/Sources/TSCclibc/include/module.modulemap",
                "header \"csqlite3.h\"",
                "header \"#{Formula["sqlite3"].opt_include/"sqlite3.h"}\""
    end

    # Fix swift-driver somehow bypassing the shims.
    inreplace workspace/"swift-driver/Utilities/build-script-helper.py",
              "-DCMAKE_C_COMPILER:=clang",
              "-DCMAKE_C_COMPILER:=#{which(ENV.cc)}"
    inreplace workspace/"swift-driver/Utilities/build-script-helper.py",
              "-DCMAKE_CXX_COMPILER:=clang++",
              "-DCMAKE_CXX_COMPILER:=#{which(ENV.cxx)}"

    # Build SwiftPM and dependents in release mode
    inreplace workspace/"swiftpm/Utilities/bootstrap",
              "-DCMAKE_BUILD_TYPE:=Debug",
              "-DCMAKE_BUILD_TYPE:=Release"

    if OS.mac?
      # String processing is only available on macOS 13+ SDK, concurrency on macOS 12+ SDK
      swiftpm_interface_build_scripts = [
        workspace/"swiftpm/Sources/PackageDescription/CMakeLists.txt",
        workspace/"swiftpm/Sources/PackagePlugin/CMakeLists.txt",
      ]
      inreplace swiftpm_interface_build_scripts,
                "-enable-library-evolution>",
                "\\0 " \
                '"$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -disable-implicit-concurrency-module-import>" ' \
                '"$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -disable-implicit-string-processing-module-import>"'

      inreplace workspace/"swiftpm/Package.swift",
                '"999.0"]),',
                '\\0 ' \
                '.unsafeFlags(["-Xfrontend", ' \
                '"-disable-implicit-concurrency-module-import"], .when(platforms: [.macOS])), ' \
                '.unsafeFlags(["-Xfrontend", ' \
                '"-disable-implicit-string-processing-module-import"], .when(platforms: [.macOS])),'
    end

    # Fix lldb Python module not being installed (needed for `swift repl`)
    lldb_cmake_caches = [
      workspace/"llvm-project/lldb/cmake/caches/Apple-lldb-macOS.cmake",
      workspace/"llvm-project/lldb/cmake/caches/Apple-lldb-Linux.cmake",
    ]
    inreplace lldb_cmake_caches, "repl_swift", "lldb-python-scripts \\0"

    mkdir build do
      # List of components to build
      swift_components = %w[
        compiler clang-resource-dir-symlink tools
        editor-integration toolchain-tools license
        sourcekit-xpc-service swift-remote-mirror
        swift-remote-mirror-headers parser-lib stdlib
        static-mirror-lib
      ]
      llvm_components = %w[
        llvm-cov llvm-profdata IndexStore clang
        clang-resource-headers compiler-rt clangd
        clang-features-file
      ]

      if OS.mac?
        swift_components << "back-deployment"
        llvm_components << "dsymutil"
      end
      if OS.linux?
        swift_components += %w[
          sdk-overlay
          autolink-driver
          sourcekit-inproc
        ]
        llvm_components << "lld"
      end

      args = %W[
        --host-cc=#{which(ENV.cc)}
        --host-cxx=#{which(ENV.cxx)}
        --release --assertions
        --no-swift-stdlib-assertions
        --build-subdir=#{build}
        --lldb --llbuild --swiftpm --swift-driver
        --swiftdocc --indexstore-db --sourcekit-lsp
        --jobs=#{ENV.make_jobs}
        --verbose-build

        --workspace=#{workspace}
        --install-destdir=#{prefix}
        --toolchain-prefix=#{toolchain_prefix}
        --install-prefix=#{install_prefix}
        --swift-include-tests=0
        --llvm-include-tests=0
        --skip-build-benchmarks
        --build-swift-private-stdlib=0
        --install-swift
        --swift-install-components=#{swift_components.join(";")}
        --install-llvm
        --llvm-install-components=#{llvm_components.join(";")}
        --install-lldb
        --install-llbuild
        --install-swiftpm
        --install-swift-driver
        --install-swiftdocc
        --install-sourcekit-lsp
      ]
      extra_cmake_options = []

      if OS.mac?
        args += %W[
          --host-target=macosx-#{Hardware::CPU.arch}
          --darwin-deployment-version-osx=#{MacOS.version}
          --build-swift-dynamic-stdlib=0
          --build-swift-dynamic-sdk-overlay=0
          --stdlib-deployment-targets=
          --swift-darwin-supported-archs=#{Hardware::CPU.arch}
          --swift-darwin-module-archs=#{Hardware::CPU.arch}
          --back-deploy-concurrency
          --install-back-deploy-concurrency
          --lldb-use-system-debugserver
        ]
        extra_cmake_options += %W[
          -DLLDB_FRAMEWORK_COPY_SWIFT_RESOURCES=0
          -DCMAKE_INSTALL_RPATH=#{loader_path}
        ]
      end
      if OS.linux?
        args += %W[
          --libcxx=0
          --foundation
          --libdispatch
          --xctest
          --skip-early-swift-driver

          --host-target=linux-#{Hardware::CPU.arch}
          --stdlib-deployment-targets=linux-#{Hardware::CPU.arch}
          --build-swift-static-stdlib
          --build-swift-static-sdk-overlay
          --install-foundation
          --install-libdispatch
          --install-xctest
        ]
        rpaths = [loader_path, rpath, rpath(target: lib/"swift/linux")]
        extra_cmake_options << "-DCMAKE_INSTALL_RPATH=#{rpaths.join(":")}"

        ENV["CMAKE_Swift_COMPILER"] = "" # Ignore our shim
      end

      args << "--extra-cmake-options=#{extra_cmake_options.join(" ")}"

      ENV["SKIP_XCODE_VERSION_CHECK"] = "1"
      system "#{workspace}/swift/utils/build-script", *args
    end

    if OS.mac?
      # Prebuild modules for faster first startup.
      ENV["SWIFT_EXEC"] = "#{prefix}#{install_prefix}/bin/swiftc"
      MacOS.sdk_locator.all_sdks.each do |sdk|
        next if sdk.version < :big_sur
        # https://github.com/apple/swift/issues/62765
        next if sdk.version == :ventura

        system "#{prefix}#{install_prefix}/bin/swift", "build-sdk-interfaces",
               "-sdk", sdk.path,
               "-o", "#{prefix}#{install_prefix}/lib/swift/macosx/prebuilt-modules",
               "-log-path", logs/"build-sdk-interfaces",
               "-v"
      end
    else
      # Strip debugging info to make the bottle relocatable.
      binaries_to_strip = Pathname.glob("#{prefix}#{install_prefix}/{bin,lib/swift/pm}/**/*").select do |f|
        f.file? && f.elf?
      end
      system "strip", "--strip-debug", "--preserve-dates", *binaries_to_strip
    end

    bin.install_symlink Dir["#{prefix}#{install_prefix}/bin/{swift,sil,sourcekit}*"]
    man1.install_symlink "#{prefix}#{install_prefix}/share/man/man1/swift.1"
    elisp.install_symlink "#{prefix}#{install_prefix}/share/emacs/site-lisp/swift-mode.el"
    doc.install_symlink Dir["#{prefix}#{install_prefix}/share/doc/swift/*"]

    rewrite_shebang detected_python_shebang, *Dir["#{prefix}#{install_prefix}/bin/*.py"]
  end

  def caveats
    on_macos do
      <<~EOS
        An Xcode toolchain has been installed to:
          #{opt_prefix}/Swift-#{version.major_minor}.xctoolchain

        This can be symlinked for use within Xcode:
          ln -s #{opt_prefix}/Swift-#{version.major_minor}.xctoolchain ~/Library/Developer/Toolchains/Swift-#{version.major_minor}.xctoolchain
      EOS
    end
  end

  test do
    # Don't use global cache which is long-lasting and often requires clearing.
    module_cache = testpath/"ModuleCache"
    module_cache.mkdir

    # Temporary hack while macOS 13 SDK prebuilding is disabled.
    if MacOS.version == :ventura
      ENV.remove_macosxsdk
      ENV["SDKROOT"] = "/Library/Developer/CommandLineTools/SDKs/MacOSX12.sdk"
    end

    (testpath/"test.swift").write <<~'EOS'
      let base = 2
      let exponent_inner = 3
      let exponent_outer = 4
      var answer = 1

      for _ in 1...exponent_outer {
        for _ in 1...exponent_inner {
          answer *= base
        }
      }

      print("(\(base)^\(exponent_inner))^\(exponent_outer) == \(answer)")
    EOS
    output = shell_output("#{bin}/swift -module-cache-path #{module_cache} -v test.swift")
    assert_match "(2^3)^4 == 4096\n", output

    # Test accessing Foundation
    (testpath/"foundation-test.swift").write <<~'EOS'
      import Foundation

      let swifty = URLComponents(string: "https://www.swift.org")!
      print("\(swifty.host!)")
    EOS
    output = shell_output("#{bin}/swift -module-cache-path #{module_cache} -v foundation-test.swift")
    assert_match "www.swift.org\n", output

    # Test compiler
    system "#{bin}/swiftc", "-module-cache-path", module_cache, "-v", "foundation-test.swift", "-o", "foundation-test"
    output = shell_output("./foundation-test")
    assert_match "www.swift.org\n", output

    # Test Swift Package Manager
    ENV["SWIFTPM_MODULECACHE_OVERRIDE"] = module_cache
    mkdir "swiftpmtest" do
      system "#{bin}/swift", "package", "init", "--type=executable"
      rm "Sources/swiftpmtest/swiftpmtest.swift"
      cp "../foundation-test.swift", "Sources/swiftpmtest/main.swift"
      system "#{bin}/swift", "build", "--verbose", "--disable-sandbox"
      assert_match "www.swift.org\n", shell_output("#{bin}/swift run --disable-sandbox")
    end

    # Make sure the default resource directory is not using a Cellar path
    default_resource_dir = JSON.parse(shell_output("#{bin}/swift -print-target-info"))["paths"]["runtimeResourcePath"]
    expected_resource_dir = if OS.mac?
      opt_prefix/"Swift-#{version.major_minor}.xctoolchain/usr/lib/swift"
    else
      opt_libexec/"lib/swift"
    end.to_s
    assert_equal expected_resource_dir, default_resource_dir
  end
end
