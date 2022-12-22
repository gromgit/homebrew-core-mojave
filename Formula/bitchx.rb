class Bitchx < Formula
  desc "Text-based, scriptable IRC client"
  homepage "https://bitchx.sourceforge.io/"
  license "BSD-3-Clause"
  revision 1
  head "https://git.code.sf.net/p/bitchx/git.git", branch: "master"

  stable do
    url "https://downloads.sourceforge.net/project/bitchx/ircii-pana/bitchx-1.2.1/bitchx-1.2.1.tar.gz"
    sha256 "2d270500dd42b5e2b191980d584f6587ca8a0dbda26b35ce7fadb519f53c83e2"

    # Apply these upstream commits to fix Linux build:
    # https://sourceforge.net/p/bitchx/git/ci/1c6ff3088ad01a15bea50f78f1b2b468db7afae9/
    # https://sourceforge.net/p/bitchx/git/ci/4f63d4892995eec6707f194b462c9fc3184ee85d/
    # Remove with next release.
    patch :DATA
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bitchx"
    rebuild 1
    sha256 mojave: "29639a6230ccf7e6f10fc51422a8677fab5ceea52d0967578329a66dec2e857f"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    plugins = %w[
      acro arcfour amp autocycle blowfish cavlink encrypt
      fserv hint identd nap pkga possum qbx qmail
    ]

    # Remove following in next release
    if build.stable?
      # AIM plugin was removed upstream:
      # https://sourceforge.net/p/bitchx/git/ci/35b1a65f03a2ca2dde31c9dbd77968587b6027d3/
      plugins << "aim"

      # Patch to fix OpenSSL detection with OpenSSL 1.1
      # A similar fix is already committed upstream:
      # https://sourceforge.net/p/bitchx/git/ci/184af728c73c379d1eee57a387b6012572794fa8/
      inreplace "configure", "SSLeay", "OpenSSL_version_num"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-ipv6",
                          "--with-plugins=#{plugins.join(",")}",
                          "--with-ssl"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"BitchX", "-v"
  end
end

__END__
diff --git a/dll/amp/layer2.c b/dll/amp/layer2.c
index d4c4d95..2b7d412 100644
--- a/dll/amp/layer2.c
+++ b/dll/amp/layer2.c
@@ -77,7 +77,7 @@ int hsize,fs,mean_frame_size;
 					   nbal=&t_nbal2;
 					   sblimit=8;
 					   break;
-				default  : /*printf(" bit alloc info no gud ");*/
+				default  : break;
 				}
 				break;
 		case 1 : switch (bitrate)	/* 1 = 48 kHz */
@@ -98,7 +98,7 @@ int hsize,fs,mean_frame_size;
 					   nbal=&t_nbal2;
 					   sblimit=8;
 					   break;
-				default  : /*printf(" bit alloc info no gud ");*/
+				default  : break;
 				}
 				break;
 		case 2 : switch (bitrate)	/* 2 = 32 kHz */
@@ -122,10 +122,10 @@ int hsize,fs,mean_frame_size;
                                    nbal=&t_nbal3;
                                    sblimit=12;
 				   break;
-			default  : /*printf("bit alloc info not ok\n");*/
+			default  : break;
 			}
 	                break;                                                    
-		default  : /*printf("sampling freq. not ok/n");*/
+		default  : break;
 	} else {
 		bit_alloc_index=&t_allocMPG2;
 		nbal=&t_nbalMPG2;
diff --git a/source/commands.c b/source/commands.c
index d140d57..7fd81d6 100644
--- a/source/commands.c
+++ b/source/commands.c
@@ -118,7 +118,6 @@ extern	int	doing_notice;
 
 static	void	oper_password_received (char *, char *);
 
-int	no_hook_notify = 0;
 int	load_depth = -1;
 
 extern char	cx_function[];
diff --git a/source/modules.c b/source/modules.c
index 52817fc..99d39bb 100644
--- a/source/modules.c
+++ b/source/modules.c
@@ -77,7 +77,7 @@ extern int BX_read_sockets();
 extern int identd;
 extern int doing_notice;
 
-int (*serv_open_func) (int, unsigned long, int);
+extern int (*serv_open_func) (int, unsigned long, int);
 extern int (*serv_output_func) (int, int, char *, int);
 extern int (*serv_input_func)  (int, char *, int, int, int);
 extern int (*serv_close_func) (int, unsigned long, int);
diff --git a/source/numbers.c b/source/numbers.c
index 741fca9..2f80f22 100644
--- a/source/numbers.c
+++ b/source/numbers.c
@@ -66,7 +66,6 @@ void	show_server_map		(void);
 int	stats_k_grep		(char **);
 void	who_handlekill		(char *, char *, char *);
 void	handle_tracekill	(int, char *, char *, char *);
-int	no_hook_notify;
 extern  AJoinList *ajoin_list;
 void	remove_from_server_list (int);
