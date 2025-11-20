class IrafSt4gem < Formula
  desc "IRAF external package for tabular spectra"
  homepage "https://github.com/iraf-community/iraf-st4gem"
  url "https://gitlab.com/nsf-noirlab/csdc/usngo/iraf/st4gem/-/archive/20251102/st4gem-20251102.tar.gz"
  sha256 "e413f61ba85fe7e1319e6874ddee3c891da1bd5f5c5c8a2898e87a36ced790e3"

  depends_on "iraf"

  def install
    rm_r Dir["bin*"]
    mkdir_p buildpath/"bin"
    ENV["st4gem"] = "#{buildpath}/"
    system "mkpkg", "-p", "st4gem"

    iraf_extern = lib/"iraf/extern"
    (iraf_extern/"st4gem").install Dir["*"]
  end

  test do
    (testpath/"version.cl").write <<~EOF
      st4gem
      =version
      logout
    EOF
    assert_match "V1.2.1", shell_output("#{HOMEBREW_PREFIX}/bin/irafcl -f version.cl")
  end
end
