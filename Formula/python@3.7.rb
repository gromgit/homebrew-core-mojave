class PythonAT37 < Formula
  desc "Interpreted, interactive, object-oriented programming language"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.7.12/Python-3.7.12.tar.xz"
  sha256 "f77bf7fb47839f213e5cbf7827281078ea90de7e72b44f10d7ef385ea8c43210"
  license "Python-2.0"
  revision 1

  livecheck do
    url "https://www.python.org/ftp/python/"
    regex(%r{href=.*?v?(3\.7(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 monterey:     "03e684d64e7ce907b690f87d38c0d4fd579cb3c84a3a567185ed8b27eed096ef"
    sha256 big_sur:      "76831700c7e63dd2373244c8aba96b09f861f179c46f9a2a7a7c00b3078fa66a"
    sha256 catalina:     "b8b0cf6f2f7efd791c23e11dca7fd955c71bbb3d664a24a799e34424c2472c57"
    sha256 mojave:       "aa8a60fbd7abed9fee6664597a0ed150cddec8dabdc99a5e0eed18bd150b0ca4"
    sha256 x86_64_linux: "de0aacaf8d47cc5d5594ef72cf631cce7635c98a2f51a028ca1b6deb55dee637"
  end

  # setuptools remembers the build flags python is built with and uses them to
  # build packages later. Xcode-only systems need different flags.
  pour_bottle? only_if: :clt_installed

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "gdbm"
  depends_on "mpdecimal"
  depends_on "openssl@1.1"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  skip_clean "bin/pip3", "bin/pip-3.4", "bin/pip-3.5", "bin/pip-3.6", "bin/pip-3.7"
  skip_clean "bin/easy_install3", "bin/easy_install-3.4", "bin/easy_install-3.5",
             "bin/easy_install-3.6", "bin/easy_install-3.7"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9a/74/de4d8c69466b6413b1616048b39f8b73d65f98c15f6202b68ccfc9550f1f/setuptools-58.0.4.tar.gz"
    sha256 "f10059f0152e0b7fb6b2edd77bcb1ecd4c9ed7048a826eb2d79f72fd2e6e237b"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/52/e1/06c018197d8151383f66ebf6979d951995cf495629fc54149491f5d157d0/pip-21.2.4.tar.gz"
    sha256 "0eb8a1516c3d138ae8689c0c1a60fde7143310832f9dc77e11d8a4bc62de193b"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/4e/be/8139f127b4db2f79c8b117c80af56a3078cc4824b5b94250c7f81a70e03b/wheel-0.37.0.tar.gz"
    sha256 "e2ef7239991699e3355d54f8e968a21bb940a1dbf34a4d226741e64462516fad"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/0c/89/412afa5f0018dccf637c2d25b9d6a41623cd22beef6797c0d67a2082ccfe/importlib_metadata-3.4.0.tar.gz"
    sha256 "fa5daa4477a7414ae34e95942e4dd07f62adf589143c875c133c1e53c4eff38d"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3a/9f/1d4b62cbe8d222539a84089eeab603d8e45ee1f897803a0ae0860400d6e7/zipp-3.5.0.tar.gz"
    sha256 "f5812b1e007e48cff63449a5e9f4e7ebea716b4111f9c4f9a645f91d579bf0c4"
  end

  # Patch for MACOSX_DEPLOYMENT_TARGET on Big Sur. Upstream currently does
  # not have plans to backport the fix to 3.7, so we're maintaining this patch
  # ourselves.
  # https://bugs.python.org/issue42504
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c4bc563a8d008ebd0e8d927c043f6dd132d3ba89/python/big-sur-3.7.patch"
    sha256 "67c99bdf0bbe0a640d70747aad514cd74602e7c4715fd15f1f9863eef257735e"
  end

  # Link against libmpdec.so.3, update for mpdecimal.h symbol cleanup.
  patch do
    url "https://www.bytereef.org/contrib/decimal-3.7.diff"
    sha256 "aa9a3002420079a7d2c6033d80b49038d490984a9ddb3d1195bb48ca7fb4a1f0"
  end

  def lib_cellar
    on_macos do
      return prefix/"Frameworks/Python.framework/Versions/#{version.major_minor}/lib/python#{version.major_minor}"
    end
    on_linux do
      return prefix/"lib/python#{version.major_minor}"
    end
  end

  def site_packages_cellar
    lib_cellar/"site-packages"
  end

  # The HOMEBREW_PREFIX location of site-packages.
  def site_packages
    HOMEBREW_PREFIX/"lib/python#{version.major_minor}/site-packages"
  end

  def install
    # Unset these so that installing pip and setuptools puts them where we want
    # and not into some other Python the user has installed.
    ENV["PYTHONHOME"] = nil
    ENV["PYTHONPATH"] = nil

    # Override the auto-detection in setup.py, which assumes a universal build.
    ENV["PYTHON_DECIMAL_WITH_MACHINE"] = "x64" if OS.mac?

    args = %W[
      --prefix=#{prefix}
      --enable-ipv6
      --datarootdir=#{share}
      --datadir=#{share}
      --enable-loadable-sqlite-extensions
      --without-ensurepip
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --with-system-libmpdec
    ]

    args << "--without-gcc" if ENV.compiler == :clang

    if OS.mac?
      args << "--enable-framework=#{frameworks}"
      args << "--with-dtrace"
    else
      args << "--enable-shared"

      # Required for the _ctypes module
      # see https://github.com/Linuxbrew/homebrew-core/pull/1007#issuecomment-252421573
      args << "--with-system-ffi"
    end

    cflags   = []
    ldflags  = []
    cppflags = []

    if MacOS.sdk_path_if_needed
      # Help Python's build system (setuptools/pip) to build things on SDK-based systems
      # The setup.py looks at "-isysroot" to get the sysroot (and not at --sysroot)
      cflags  << "-isysroot #{MacOS.sdk_path}"
      ldflags << "-isysroot #{MacOS.sdk_path}"
      # For the Xlib.h, Python needs this header dir with the system Tk
      # Yep, this needs the absolute path where zlib needed a path relative
      # to the SDK.
      cflags << "-isystem #{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
    end
    # Avoid linking to libgcc https://mail.python.org/pipermail/python-dev/2012-February/116205.html
    args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"

    # Python's setup.py parses CPPFLAGS and LDFLAGS to learn search
    # paths for the dependencies of the compiled extension modules.
    # See Linuxbrew/linuxbrew#420, Linuxbrew/linuxbrew#460, and Linuxbrew/linuxbrew#875
    if OS.linux?
      cppflags << ENV.cppflags << " -I#{HOMEBREW_PREFIX}/include"
      ldflags << ENV.ldflags << " -L#{HOMEBREW_PREFIX}/lib"
    end

    # We want our readline! This is just to outsmart the detection code,
    # superenv makes cc always find includes/libs!
    inreplace "setup.py",
      "do_readline = self.compiler.find_library_file(lib_dirs, 'readline')",
      "do_readline = '#{Formula["readline"].opt_lib}/#{shared_library("libhistory")}'"

    inreplace "setup.py" do |s|
      s.gsub! "sqlite_setup_debug = False", "sqlite_setup_debug = True"
      s.gsub! "for d_ in inc_dirs + sqlite_inc_paths:",
              "for d_ in ['#{Formula["sqlite"].opt_include}']:"
    end

    if OS.linux?
      # Python's configure adds the system ncurses include entry to CPPFLAGS
      # when doing curses header check. The check may fail when there exists
      # a 32-bit system ncurses (conflicts with the brewed 64-bit one).
      # See https://github.com/Homebrew/linuxbrew-core/pull/22307#issuecomment-781896552
      # We want our ncurses! Override system ncurses includes!
      inreplace "configure",
        'CPPFLAGS="$CPPFLAGS -I/usr/include/ncursesw"',
        "CPPFLAGS=\"$CPPFLAGS -I#{Formula["ncurses"].opt_include}\""
    end

    # Allow python modules to use ctypes.find_library to find homebrew's stuff
    # even if homebrew is not a /usr/local/lib. Try this with:
    # `brew install enchant && pip install pyenchant`
    inreplace "./Lib/ctypes/macholib/dyld.py" do |f|
      f.gsub! "DEFAULT_LIBRARY_FALLBACK = [", "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}/lib',"
      f.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [", "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}/Frameworks',"
    end

    args << "CFLAGS=#{cflags.join(" ")}" unless cflags.empty?
    args << "LDFLAGS=#{ldflags.join(" ")}" unless ldflags.empty?
    args << "CPPFLAGS=#{cppflags.join(" ")}" unless cppflags.empty?

    system "./configure", *args
    system "make"

    ENV.deparallelize do
      # Tell Python not to install into /Applications (default for framework builds)
      system "make", "install", "PYTHONAPPSDIR=#{prefix}"
      system "make", "frameworkinstallextras", "PYTHONAPPSDIR=#{pkgshare}" if OS.mac?
    end

    # Any .app get a " 3" attached, so it does not conflict with python 2.x.
    Dir.glob("#{prefix}/*.app") { |app| mv app, app.sub(/\.app$/, " 3.app") }

    if OS.mac?
      # Prevent third-party packages from building against fragile Cellar paths
      inreplace Dir[lib_cellar/"**/_sysconfigdata_m_darwin_darwin.py",
                    lib_cellar/"config*/Makefile",
                    frameworks/"Python.framework/Versions/3*/lib/pkgconfig/python-3.?.pc"],
                prefix, opt_prefix

      # Help third-party packages find the Python framework
      inreplace Dir[lib_cellar/"config*/Makefile"],
                /^LINKFORSHARED=(.*)PYTHONFRAMEWORKDIR(.*)/,
                "LINKFORSHARED=\\1PYTHONFRAMEWORKINSTALLDIR\\2"

      # Fix for https://github.com/Homebrew/homebrew-core/issues/21212
      inreplace Dir[lib_cellar/"**/_sysconfigdata_m_darwin_darwin.py"],
                %r{('LINKFORSHARED': .*?)'(Python.framework/Versions/3.\d+/Python)'}m,
                "\\1'#{opt_prefix}/Frameworks/\\2'"
    else
      # Prevent third-party packages from building against fragile Cellar paths
      inreplace Dir[lib_cellar/"**/_sysconfigdata_m_linux_x86_64-*.py",
                    lib_cellar/"config*/Makefile",
                    lib/"pkgconfig/python-3.?.pc"],
                prefix, opt_prefix
    end

    # Symlink the pkgconfig files into HOMEBREW_PREFIX so they're accessible.
    (lib/"pkgconfig").install_symlink Dir["#{frameworks}/Python.framework/Versions/#{version.major_minor}/lib/pkgconfig/*"]

    # Remove the site-packages that Python created in its Cellar.
    site_packages_cellar.rmtree

    %w[setuptools pip wheel importlib-metadata zipp].each do |r|
      (libexec/r).install resource(r)
    end

    # Remove wheel test data.
    # It's for people editing wheel and contains binaries which fail `brew linkage`.
    rm libexec/"wheel/tox.ini"
    rm_r libexec/"wheel/tests"

    # Install unversioned symlinks in libexec/bin.
    {
      "idle"          => "idle3",
      "pydoc"         => "pydoc3",
      "python"        => "python3",
      "python-config" => "python3-config",
    }.each do |unversioned_name, versioned_name|
      (libexec/"bin").install_symlink (bin/versioned_name).realpath => unversioned_name
    end
  end

  def post_install
    ENV.delete "PYTHONPATH"

    # Fix up the site-packages so that user-installed Python software survives
    # minor updates, such as going from 3.3.2 to 3.3.3:

    # Create a site-packages in HOMEBREW_PREFIX/lib/python#{version.major_minor}/site-packages
    site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    site_packages_cellar.unlink if site_packages_cellar.exist?
    site_packages_cellar.parent.install_symlink site_packages

    # Write our sitecustomize.py
    rm_rf Dir["#{site_packages}/sitecustomize.py[co]"]
    (site_packages/"sitecustomize.py").atomic_write(sitecustomize)

    # Remove old setuptools installations that may still fly around and be
    # listed in the easy_install.pth. This can break setuptools build with
    # zipimport.ZipImportError: bad local file header
    # setuptools-0.9.8-py3.3.egg
    rm_rf Dir["#{site_packages}/setuptools*"]
    rm_rf Dir["#{site_packages}/distribute*"]
    rm_rf Dir["#{site_packages}/pip[-_.][0-9]*", "#{site_packages}/pip"]

    %w[setuptools pip wheel importlib-metadata zipp].each do |pkg|
      (libexec/pkg).cd do
        system bin/"python3", "-s", "setup.py", "--no-user-cfg", "install",
               "--force", "--verbose", "--install-scripts=#{bin}",
               "--install-lib=#{site_packages}",
               "--single-version-externally-managed",
               "--record=installed.txt"
      end
    end

    rm_rf [bin/"pip", bin/"easy_install"]
    mv bin/"wheel", bin/"wheel3"

    # Install unversioned symlinks in libexec/bin.
    {
      "pip"   => "pip3",
      "wheel" => "wheel3",
    }.each do |unversioned_name, versioned_name|
      (libexec/"bin").install_symlink (bin/versioned_name).realpath => unversioned_name
    end

    # Help distutils find brewed stuff when building extensions
    include_dirs = [HOMEBREW_PREFIX/"include", Formula["openssl@1.1"].opt_include,
                    Formula["sqlite"].opt_include]
    library_dirs = [HOMEBREW_PREFIX/"lib", Formula["openssl@1.1"].opt_lib,
                    Formula["sqlite"].opt_lib]

    cfg = lib_cellar/"distutils/distutils.cfg"

    cfg.atomic_write <<~EOS
      [install]
      prefix=#{HOMEBREW_PREFIX}

      [build_ext]
      include_dirs=#{include_dirs.join ":"}
      library_dirs=#{library_dirs.join ":"}
    EOS
  end

  def sitecustomize
    <<~EOS
      # This file is created by Homebrew and is executed on each python startup.
      # Don't print from here, or else python command line scripts may fail!
      # <https://docs.brew.sh/Homebrew-and-Python>
      import re
      import os
      import sys

      if sys.version_info[0] != 3:
          # This can only happen if the user has set the PYTHONPATH for 3.x and run Python 2.x or vice versa.
          # Every Python looks at the PYTHONPATH variable and we can't fix it here in sitecustomize.py,
          # because the PYTHONPATH is evaluated after the sitecustomize.py. Many modules (e.g. PyQt4) are
          # built only for a specific version of Python and will fail with cryptic error messages.
          # In the end this means: Don't set the PYTHONPATH permanently if you use different Python versions.
          exit('Your PYTHONPATH points to a site-packages dir for Python 3.x but you are running Python ' +
               str(sys.version_info[0]) + '.x!\\n     PYTHONPATH is currently: "' + str(os.environ['PYTHONPATH']) + '"\\n' +
               '     You should `unset PYTHONPATH` to fix this.')

      # Only do this for a brewed python:
      if os.path.realpath(sys.executable).startswith('#{rack}'):
          # Shuffle /Library site-packages to the end of sys.path
          library_site = '/Library/Python/#{version.major_minor}/site-packages'
          library_packages = [p for p in sys.path if p.startswith(library_site)]
          sys.path = [p for p in sys.path if not p.startswith(library_site)]
          # .pth files have already been processed so don't use addsitedir
          sys.path.extend(library_packages)

          # the Cellar site-packages is a symlink to the HOMEBREW_PREFIX
          # site_packages; prefer the shorter paths
          long_prefix = re.compile(r'#{rack}/[0-9\._abrc]+/Frameworks/Python\.framework/Versions/#{version.major_minor}/lib/python#{version.major_minor}/site-packages')
          sys.path = [long_prefix.sub('#{site_packages}', p) for p in sys.path]

          # Set the sys.executable to use the opt_prefix. Only do this if PYTHONEXECUTABLE is not
          # explicitly set and we are not in a virtualenv:
          if 'PYTHONEXECUTABLE' not in os.environ and sys.prefix == sys.base_prefix:
              sys.executable = '#{opt_bin}/python#{version.major_minor}'
    EOS
  end

  def caveats
    <<~EOS
      Python has been installed as
        #{opt_bin}/python3

      Unversioned symlinks `python`, `python-config`, `pip` etc. pointing to
      `python3`, `python3-config`, `pip3` etc., respectively, have been installed into
        #{opt_libexec}/bin

      You can install Python packages with
        #{opt_bin}/pip3 install <package>
      They will install into the site-package directory
        #{HOMEBREW_PREFIX/"lib/python#{version.major_minor}/site-packages"}

      See: https://docs.brew.sh/Homebrew-and-Python
    EOS
  end

  test do
    # Check if sqlite is ok, because we build with --enable-loadable-sqlite-extensions
    # and it can occur that building sqlite silently fails if OSX's sqlite is used.
    system "#{bin}/python#{version.major_minor}", "-c", "import sqlite3"
    # Check if some other modules import. Then the linked libs are working.

    on_macos do
      # Temporary failure on macOS 11.1 due to https://bugs.python.org/issue42480
      # Reenable unconditionnaly once Apple fixes the Tcl/Tk issue
      system "#{bin}/python#{version.major_minor}", "-c", "import tkinter; root = tkinter.Tk()" if MacOS.full_version < "11.1"
    end

    system "#{bin}/python#{version.major_minor}", "-c", "import _decimal"
    system "#{bin}/python#{version.major_minor}", "-c", "import _gdbm"
    system "#{bin}/python#{version.major_minor}", "-c", "import zlib"
    system bin/"pip3", "list", "--format=columns"
  end
end
