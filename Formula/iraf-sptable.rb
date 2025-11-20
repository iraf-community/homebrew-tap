class IrafSptable < Formula
  desc "IRAF external package for tabular spectra"
  homepage "https://github.com/iraf-community/iraf-sptable"
  url "https://github.com/iraf-community/iraf-sptable/archive/refs/tags/1.0.pre20180612.tar.gz"
  sha256 "c241f936cd8ebb3fe45d22e6d72a78b0802b5aacd3673e6eab4f764a50fffc33"

  depends_on "iraf"

  def install
    rm "bin"
    mkdir_p "bin"
    ENV["sptable"] = "#{buildpath}/"
    system "mkpkg", "-p", "sptable"

    iraf_extern = lib/"iraf/extern"
    (iraf_extern/"sptable").install Dir["*"]
  end

  test do
    (testpath/"version.cl").write <<~EOF
      sptable
      =version
      logout
    EOF
    assert_match "V1.0: 20180612", shell_output("#{HOMEBREW_PREFIX}/bin/irafcl -f version.cl")
  end
end
