{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "bluetooth-monitor";
  version = "unstable-2018-06-08";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "freedreamer82";
    repo = "bluetooth-monitor";
    rev = "435aca7df5569e28f9e82934df55a0d04c65700d";
    hash = "sha256-A4DD0sPICxAUoR6rADK0GzwYNpUPb5Nuyk+0GLou5gc=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pydbus
    pygobject3
  ];

  dontBuild = true;

  # Patch Python 2 to Python 3
  postPatch = ''
    substituteInPlace bluetooth-monitor.py \
      --replace-fail "import ConfigParser" "import configparser as ConfigParser" \
      --replace-fail "print('\r\nYou pressed Ctrl+C! Game Over...')" "print('\r\nYou pressed Ctrl+C! Game Over...')" \
      --replace-fail "import commands" "import subprocess"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 bluetooth-monitor.py $out/bin/bluetooth-monitor
    
    runHook postInstall
  '';

  postInstall = ''
    # Install example config
    install -Dm644 config.ini $out/share/bluetooth-monitor/config.ini.example
    
    # Install systemd service template
    install -Dm644 misc/bluetooth-monitor.service $out/lib/systemd/system/bluetooth-monitor.service
  '';

  # No tests in repository
  doCheck = false;

  meta = {
    description = "Linux daemon listening for Bluetooth device connections via D-Bus";
    longDescription = ''
      bluetooth-monitor listens to BlueZ D-Bus API for device connection and
      disconnection events, allowing execution of shell commands per device.
      Similar to udev rules but for Bluetooth devices.
    '';
    homepage = "https://github.com/freedreamer82/bluetooth-monitor";
    license = lib.licenses.gpl3Only;
    mainProgram = "bluetooth-monitor.py";
    platforms = lib.platforms.linux;
  };
})
