{ lib, fetchPypi, python3Packages }:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "jira2markdown";
  version = "0.5";

  pyproject = true;

  disabled = python3Packages.pythonOlder "3.9";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-OWaQllgzI05vcAHowt05NM3ulj/+iohc+zy+MJEh6BA=";
  };

  nativeBuildInputs = [
    python3Packages.poetry-core
  ];

  propagatedBuildInputs = [
    python3Packages.pyparsing
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
