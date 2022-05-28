class Phpmyadmin < Formula
  desc "Web interface for MySQL and MariaDB"
  homepage "https://www.phpmyadmin.net"
  url "https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.tar.gz"
  sha256 "f794528eebf1b723a29b89d239963e979a251fb484fd6e788919bf8cbca7db39"

  livecheck do
    url "https://www.phpmyadmin.net/files/"
    regex(/href=.*?phpMyAdmin[._-]v?(\d+(?:\.\d+)+)-all-languages\.zip["' >]/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/phpmyadmin"
    sha256 cellar: :any_skip_relocation, mojave: "8c80ccb75e050a56bbb7151d5ac673ef07b8e4885babe1350dd10b772aad62db"
  end

  depends_on "php" => :test

  def install
    pkgshare.install Dir["*"]

    etc.install pkgshare/"config.sample.inc.php" => "phpmyadmin.config.inc.php"
    ln_s etc/"phpmyadmin.config.inc.php", pkgshare/"config.inc.php"
  end

  def caveats
    <<~EOS
      To enable phpMyAdmin in Apache, add the following to httpd.conf and
      restart Apache:
          Alias /phpmyadmin #{HOMEBREW_PREFIX}/share/phpmyadmin
          <Directory #{HOMEBREW_PREFIX}/share/phpmyadmin/>
              Options Indexes FollowSymLinks MultiViews
              AllowOverride All
              <IfModule mod_authz_core.c>
                  Require all granted
              </IfModule>
              <IfModule !mod_authz_core.c>
                  Order allow,deny
                  Allow from all
              </IfModule>
          </Directory>
      Then open http://localhost/phpmyadmin
      The configuration file is #{etc}/phpmyadmin.config.inc.php
    EOS
  end

  test do
    cd pkgshare do
      assert_match "German", shell_output("php #{pkgshare}/index.php")
    end
  end
end
