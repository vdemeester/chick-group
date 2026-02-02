{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

let
  jira2markdown = python3Packages.callPackage ./jira2markdown.nix { };
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "jayrah";
  version = "0.1.0";

  pyproject = true;

  disabled = python3Packages.pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "jayrah";
    rev = finalAttrs.version;
    hash = "sha256-repl0vWZ8BSd+ZIfQBYQvCfYB0cewoGqUcM4+cclwEw=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.wheel
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'py-modules = ["jayrah"]' 'packages = { find = { include = ["jayrah*"] } }'
  '';

  propagatedBuildInputs = [
    python3Packages.click
    python3Packages.fastapi
    python3Packages.mcp
    python3Packages.pyyaml
    python3Packages.rich
    python3Packages.textual
    python3Packages.textual-dev
    python3Packages.uvicorn
    jira2markdown
  ];

  pythonImportsCheck = [
    "jayrah"
  ];

  doCheck = false;

  meta = {
    description = "CLI and TUI for working with Jira from the terminal";
    homepage = "https://github.com/chmouel/jayrah";
    license = lib.licenses.asl20;
    mainProgram = "jayrah";
  };
})
