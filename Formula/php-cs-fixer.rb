class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.3.2/php-cs-fixer.phar"
  sha256 "8a7cb6fcbf916f01d4b423b7850b4401bc687275011b6f437322679a4fc4613f"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c7ae560f6187651f5517778dc71c6e3be71fd4cf50bf49c2091bf7f3f6811d2"
  end

  depends_on "php@8.0"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php@8.0"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    EOS
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system "#{bin}/php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
