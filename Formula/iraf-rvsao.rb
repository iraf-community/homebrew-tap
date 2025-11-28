class IrafRvsao < Formula
  desc "IRAF package to obtain radial velocities from spectra"
  homepage "https://github.com/iraf-community/iraf-rvsao"
  url "http://tdc-www.harvard.edu/iraf/rvsao/rvsao-2.8.5.tar.gz"
  sha256 "0ccd06a4ff4ba5a344787406145f1348ba0cfbaf7771e51e0356ce8e93979b1a"

  IRAF_PACKAGE = "rvsao".freeze

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-rvsao-2.8.5"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ccb007d908f13fbcdddd99f25631490538591fa57c24ac10494f5aa90478721"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "107cb8ff1b154dd19ad962728e8e608ba62e3f64bb04b00270bbfa25c72ca503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "155188a98aedc66cac0f6faad1461cf01d1e8c3e18e2a53f0d92a28d645b11e0"
    sha256 cellar: :any_skip_relocation, sequoia:       "c458a38fdfdbb19842648ed54007d2167394c640e65572af08a4765979b3887b"
  end

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
