class IrafCtio < Formula
  desc "Tools for the Cerro Tololo Inter-American Observatory"
  homepage "https://github.com/iraf-community/iraf-ctio"
  url "https://github.com/iraf-community/iraf-ctio.git", revision: "a6113fe"
  version "2023.11.12"
  sha256 "987dbc80e2df98624b192a03d7829f717f51aa70580ea7a8ed3ef24f09aa2708"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-ctio-2023.11.12"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8a3dc38de030e059fb760c8e954e531ee15c28c9bec184d3738532011ac4f58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8d1dfc36045561b3024eecb65d3ff72a79b90071dac60e1d8e719cd4188d79f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74aabc5402a2b982e91b11103a5845d4f46839aa3636f9fc235264c61b7338b5"
    sha256 cellar: :any_skip_relocation, tahoe:         "27a574ce3816a1af12f531cbe9d3954a6e4e3a6008fa0dd908a416db8502a620"
    sha256 cellar: :any_skip_relocation, sequoia:       "3e2038e43c661d4346ea24b186bd33b1714728407d301b8c4b5b1c9de2efcda3"
  end

  IRAF_PACKAGE = "ctio".freeze

  depends_on "iraf"

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
