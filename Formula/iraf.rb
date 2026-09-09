class Iraf < Formula
  desc "Image Reduction and Analysis Facility"
  homepage "https://github.com/iraf-community/iraf"
  url "https://github.com/iraf-community/iraf/archive/refs/tags/v2.18.2.tar.gz"
  sha256 "a2ae5ab3f72262f6145f5b187d8cb0793beb0ee3fc1180d4f843c747749c89ef"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-2.18.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aed398e01f2813367593a18878899a92726c0f4754c4c9e0769782c9a0843a32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05ea2b09b8d49923b90188a744382972ec72f5d825e679c1fc1433556e5d56e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "022e1aec6645d5a2ae8ebac8e1217d7a6670d95d65cff271a9df03da7de88b8c"
    sha256 cellar: :any_skip_relocation, tahoe:         "31eac063b4eecf28d69efe1ddc465b5ed6546c0a5e9eff0c34a5a7413bab1350"
    sha256 cellar: :any_skip_relocation, sequoia:       "e2c1b939b3456186e7624c516d96e3de3d6c2ad1d4208e1535f1c6c1aad646d3"
  end

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "libedit"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # Replace yacc by "bison -y" to work around glitches with XCode
  # command line tools on older machines (Sonoma)
  patch :DATA

  def install
    system "make", "IRAFARCH="
    system "make", "install", "DESTDIR=build", "prefix=/usr"

    libexec.install Dir["build/usr/lib/iraf/*"]
    share.install Dir["build/usr/share/*"]

    env = { "iraf" => "#{libexec}/" }
    (bin/"irafcl").write_env_script libexec/"unix/hlib/irafcl.sh", env
    (bin/"cl").write_env_script libexec/"unix/hlib/irafcl.sh", env
    (bin/"ecl").write_env_script libexec/"unix/hlib/irafcl.sh", env
    (bin/"mkiraf").write_env_script libexec/"unix/hlib/mkiraf.sh", env
    (bin/"mkpkg").write_env_script libexec/"unix/bin/mkpkg.e", env
    (bin/"rmbin").write_env_script libexec/"unix/bin/rmbin.e", env
    (bin/"rmfiles").write_env_script libexec/"unix/bin/rmfiles.e", env
    (bin/"rtar").write_env_script libexec/"unix/bin/rtar.e", env
    (bin/"wtar").write_env_script libexec/"unix/bin/wtar.e", env
    (bin/"xc").write_env_script libexec/"unix/bin/xc.e", env
    (bin/"xyacc").write_env_script libexec/"unix/bin/xyacc.e", env
    (bin/"sgidispatch").write_env_script libexec/"unix/bin/sgidispatch.e", env
    rm_r libexec/"extern"
    iraf_extern = HOMEBREW_PREFIX/"lib/iraf/extern"
    libexec.install_symlink iraf_extern => "extern"
  end

  post_install_steps do
    mkdir_p "lib/iraf/extern", base: :homebrew_prefix
  end

  def caveats
    <<~EOS
      If x11iraf is installed, "irafcl -x" will start a new xgterm
      window with IRAF. External software may require to set the
      "iraf" environment variable to:

        export iraf=#{opt_libexec}/
    EOS
  end

  test do
    # Extract the version string of the package directly from the .par
    # file and check whether it can be reproduced from the
    # corresponding IRAF variable.
    ref = shell_output("grep ^version, #{opt_libexec}/pkg/ecl/cl.par  | cut -d\\\" -f2")
    ver = shell_output("#{bin}/irafcl -c =version")
    puts "'#{ref}' == '#{ver}'?"
    assert_match ref, ver
  end
end

__END__
diff --git a/pkg/cl/mkpkg b/pkg/cl/mkpkg
index 05623fcca..9e9dacc88 100644
--- a/pkg/cl/mkpkg
+++ b/pkg/cl/mkpkg
@@ -23,7 +23,7 @@ relink:
 	    $endif
 	    $ifolder (ytab.c,  grammar.y)
 		$echo "rebuilding ytab.c"
-		!yacc -vd grammar.y;
+		!bison -y -vd grammar.y;
 		!grep -v "\<stdlib.h\>" y.tab.c > ytab.c;
 		!mv y.tab.h ytab.h
 	    $endif
diff --git a/pkg/ecl/mkpkg b/pkg/ecl/mkpkg
index 4b2182a81..7bf167c41 100644
--- a/pkg/ecl/mkpkg
+++ b/pkg/ecl/mkpkg
@@ -23,7 +23,7 @@ relink:
 	    $endif
 	    $ifolder (ytab.c,  grammar.y)
 		$echo "rebuilding ytab.c"
-		!yacc -vd grammar.y;
+		!bison -y -vd grammar.y;
 		!grep -v "\<stdlib.h\>" y.tab.c > ytab.c;
 		!mv y.tab.h ytab.h
 	    $endif
