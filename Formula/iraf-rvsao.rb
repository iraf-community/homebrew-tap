class IrafRvsao < Formula
  desc "IRAF package to obtain radial velocities from spectra"
  homepage "https://github.com/iraf-community/iraf-rvsao"
  url "http://tdc-www.harvard.edu/iraf/rvsao/rvsao-2.8.5.tar.gz"
  sha256 "0ccd06a4ff4ba5a344787406145f1348ba0cfbaf7771e51e0356ce8e93979b1a"

  depends_on "iraf"

  patch :DATA

  def install
    rm "bin"
    mkdir_p "bin"
    ENV["rvsao"] = "#{buildpath}/"
    system "mkpkg", "-p", "rvsao"

    iraf_extern = lib/"iraf/extern"
    (iraf_extern/"rvsao").install Dir["*"]
  end

  test do
    (testpath/"version.cl").write <<~EOF
      rvsao
      =version
      logout
    EOF
    assert_match "RVSAO 2.8.5, March 15, 2022", shell_output("#{HOMEBREW_PREFIX}/bin/irafcl -f version.cl")
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
