class IrafSt4gem < Formula
  desc "IRAF external package for tabular spectra"
  homepage "https://github.com/iraf-community/iraf-st4gem"
  url "https://gitlab.com/nsf-noirlab/csdc/usngo/iraf/st4gem.git",
      tag: "v1.2.1", revision: "e61f8c2f69265feb849fe065d409cf41bd635473"

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
