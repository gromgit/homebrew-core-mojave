class RubyAT26 < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  url "https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.9.tar.xz"
  sha256 "6a041d82ae6e0f02ccb1465e620d94a7196489d8a13d6018a160da42ebc1eece"
  license "Ruby"

  livecheck do
    url "https://www.ruby-lang.org/en/downloads/"
    regex(/href=.*?ruby[._-]v?(2\.6(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ruby@2.6"
    rebuild 2
    sha256 mojave: "3cf06340c2e69fb92e9577761974258bb3dcea21d2c7f4ae3a3158bcc64fd3ec"
  end

  keg_only :versioned_formula

  deprecate! date: "2022-04-05", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "zlib"

  def api_version
    "2.6.0"
  end

  def rubygems_bindir
    HOMEBREW_PREFIX/"lib/ruby/gems/#{api_version}/bin"
  end

  def install
    # otherwise `gem` command breaks
    ENV.delete("SDKROOT")

    paths = %w[libyaml openssl@1.1 readline].map { |f| Formula[f].opt_prefix }
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --disable-silent-rules
      --with-sitedir=#{HOMEBREW_PREFIX}/lib/ruby/site_ruby
      --with-vendordir=#{HOMEBREW_PREFIX}/lib/ruby/vendor_ruby
      --with-opt-dir=#{paths.join(":")}
      --without-gmp
    ]
    args << "--disable-dtrace" if OS.mac? && !MacOS::CLT.installed?

    # Correct MJIT_CC to not use superenv shim
    args << "MJIT_CC=/usr/bin/#{DevelopmentTools.default_compiler}"

    system "./configure", *args

    # Ruby has been configured to look in the HOMEBREW_PREFIX for the
    # sitedir and vendordir directories; however we don't actually want to create
    # them during the install.
    #
    # These directories are empty on install; sitedir is used for non-rubygems
    # third party libraries, and vendordir is used for packager-provided libraries.
    inreplace "tool/rbinstall.rb" do |s|
      s.gsub! 'prepare "extension scripts", sitelibdir', ""
      s.gsub! 'prepare "extension scripts", vendorlibdir', ""
      s.gsub! 'prepare "extension objects", sitearchlibdir', ""
      s.gsub! 'prepare "extension objects", vendorarchlibdir', ""
    end

    system "make"
    system "make", "install"

    # A newer version of ruby-mode.el is shipped with Emacs
    elisp.install Dir["misc/*.el"].reject { |f| f == "misc/ruby-mode.el" }
  end

  def post_install
    # Customize rubygems to look/install in the global gem directory
    # instead of in the Cellar, making gems last across reinstalls
    config_file = lib/"ruby/#{api_version}/rubygems/defaults/operating_system.rb"
    config_file.unlink if config_file.exist?
    config_file.write rubygems_config(api_version)

    # Create the sitedir and vendordir that were skipped during install
    %w[sitearchdir vendorarchdir].each do |dir|
      mkdir_p `#{bin}/ruby -rrbconfig -e 'print RbConfig::CONFIG["#{dir}"]'`
    end
  end

  def rubygems_config(api_version)
    <<~EOS
      module Gem
        class << self
          alias :old_default_dir :default_dir
          alias :old_default_path :default_path
          alias :old_default_bindir :default_bindir
          alias :old_ruby :ruby
        end

        def self.default_dir
          path = [
            "#{HOMEBREW_PREFIX}",
            "lib",
            "ruby",
            "gems",
            "#{api_version}"
          ]

          @homebrew_path ||= File.join(*path)
        end

        def self.private_dir
          path = if defined? RUBY_FRAMEWORK_VERSION then
                   [
                     File.dirname(RbConfig::CONFIG['sitedir']),
                     'Gems',
                     RbConfig::CONFIG['ruby_version']
                   ]
                 elsif RbConfig::CONFIG['rubylibprefix'] then
                   [
                    RbConfig::CONFIG['rubylibprefix'],
                    'gems',
                    RbConfig::CONFIG['ruby_version']
                   ]
                 else
                   [
                     RbConfig::CONFIG['libdir'],
                     ruby_engine,
                     'gems',
                     RbConfig::CONFIG['ruby_version']
                   ]
                 end

          @private_dir ||= File.join(*path)
        end

        def self.default_path
          if Gem.user_home && File.exist?(Gem.user_home)
            [user_dir, default_dir, old_default_dir, private_dir]
          else
            [default_dir, old_default_dir, private_dir]
          end
        end

        def self.default_bindir
          "#{rubygems_bindir}"
        end

        def self.ruby
          "#{opt_bin}/ruby"
        end

        # https://github.com/Homebrew/homebrew-core/issues/40872#issuecomment-542092547
        class BasicSpecification
          def self.default_specifications_dir
            File.join(Gem.old_default_dir, "specifications", "default")
          end
        end
      end
    EOS
  end

  def caveats
    <<~EOS
      By default, binaries installed by gem will be placed into:
        #{rubygems_bindir}

      You may want to add this to your PATH.
    EOS
  end

  test do
    hello_text = shell_output("#{bin}/ruby -e 'puts :hello'")
    assert_equal "hello\n", hello_text
    ENV["GEM_HOME"] = testpath
    system "#{bin}/gem", "install", "json"

    (testpath/"Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'gemoji'
    EOS
    system bin/"bundle", "install", "--binstubs=#{testpath}/bin"
    assert_predicate testpath/"bin/gemoji", :exist?, "gemoji is not installed in #{testpath}/bin"
  end
end
