class IrafRvsao < Formula
  desc "IRAF package to obtain radial velocities from spectra"
  homepage "https://github.com/iraf-community/iraf-rvsao"
  url "http://tdc-www.harvard.edu/iraf/rvsao/rvsao-2.8.5.tar.gz"
  sha256 "0ccd06a4ff4ba5a344787406145f1348ba0cfbaf7771e51e0356ce8e93979b1a"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-rvsao-2.8.5"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c10d25b3bdd057d81479934f9cda8637b7d81f66c246e8b3cc8c1453ad30037"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "977fe98684dd040f4d06bd9f4b7f58e85160f05383532cb3fa532f1893968e79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "406c18e74a2756eb55c20c4fbdee98cba5536c5e61b922b35b94ca8055fc00e4"
    sha256 cellar: :any_skip_relocation, tahoe:         "de472a3862315a024e77c94f99adcb9f2299b92cc9184e8b6f338d3d9faec40a"
    sha256 cellar: :any_skip_relocation, sequoia:       "9fb241a3c644053b05ff9c2778ee487031b06bab3e9991eb534a50dd4ee57221"
  end

  IRAF_PACKAGE = "rvsao".freeze

  depends_on "iraf"

  patch :DATA

  def install
    rm "bin"
    mkdir_p "bin"
    ENV[IRAF_PACKAGE] = "#{buildpath}/"
    system "mkpkg", "-p", IRAF_PACKAGE
    system "irafcl", "-c", "softools; mkhelpdb helpdir=lib$root.hd helpdb=lib$helpdb.mip"

    iraf_extern = lib/"iraf/extern"
    (iraf_extern/IRAF_PACKAGE).install Dir["*"]
  end

  test do
    # Extract the version string of the package directly from the .par
    # file and check whether it can be reproduced from the
    # corresponding IRAF variable.
    ref = shell_output("grep ^version, #{lib}/iraf/extern/#{IRAF_PACKAGE}/#{IRAF_PACKAGE}.par  | cut -d\\\" -f2")
    ver = shell_output("irafcl -c #{IRAF_PACKAGE} -c =version")
    puts "'#{ref}' == '#{ver}'?"
    assert_match ref, ver
  end
end

__END__
diff --git a/mkpkg b/mkpkg
index c6a6e1c..5f5cb9a 100644
--- a/mkpkg
+++ b/mkpkg
@@ -14,8 +14,7 @@ install:
 	;
 
 relink:
-#	!mkpkg -p noao -p rvsao nrelink
-	!mkpkg nrelink
+	!mkpkg -p noao nrelink
 	;
  
 nrelink:
