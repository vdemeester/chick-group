{ lib, fetchPypi, python3 }:

python3.pkgs.buildPythonPackage (finalAttrs: {
  pname = "jira2markdown";
  version = "0.5";

  pyproject = true;

  disabled = python3.pkgs.pythonOlder "3.9";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-OWaQllgzI05vcAHowt05NM3ulj/+iohc+zy+MJEh6BA=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = [
    python3.pkgs.pyparsing
  ];

  pythonImportsCheck = [
    "jira2markdown"
  ];

  doCheck = false;

  meta = {
    description = "Convert text from JIRA markup to Markdown using parsing expression grammars";
    homepage = "https://github.com/catcombo/jira2markdown";
    license = lib.licenses.mit;
  };
})
