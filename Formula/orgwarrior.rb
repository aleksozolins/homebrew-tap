# orgwarrior and orgwarrior-web in one formula: two formulae can't share a
# Python package, and the page uses orgwarrior's engine.
class Orgwarrior < Formula
  include Language::Python::Virtualenv

  desc "Taskwarrior-style command line and web page for Org mode's agenda"
  homepage "https://github.com/aleksozolins/orgwarrior"
  url "https://files.pythonhosted.org/packages/source/o/orgwarrior/orgwarrior-0.5.2.tar.gz"
  sha256 "c6d3f8cb5a29ca43c0ca1be1f8319e1fe9683e578df84cd56539b1c074e3a9eb"
  license "GPL-3.0-or-later"

  depends_on "python@3.13"

  resource "orgwarrior-web" do
    url "https://files.pythonhosted.org/packages/source/o/orgwarrior-web/orgwarrior_web-0.5.1.tar.gz"
    sha256 "8a3e876b9a7d6fbe0926ff7db67eba85957ca6cc176fc4f4c97a76e073ff4879"
  end

  def install
    # Both commands linked by hand: orgwarrior-web's package brings
    # orgwarrior's command too, so pip_install_and_link, which links only what
    # orgwarrior newly adds, found it there already and linked nothing.
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources
    venv.pip_install buildpath
    bin.install_symlink libexec/"bin/orgwarrior", libexec/"bin/orgwarrior-web"
    man1.install "docs/orgwarrior.1"
  end

  def caveats
    <<~EOS
      orgwarrior talks to a running Emacs daemon (emacs --daemon), Emacs 29
      or later, from Homebrew or wherever yours comes from.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orgwarrior --version")
    assert_match "orgwarrior-web", shell_output("#{bin}/orgwarrior-web --help")
  end
end
