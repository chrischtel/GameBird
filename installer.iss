[Setup]
AppName=GameBird
AppVersion=0.1.0
AppPublisher=GameBird
AppPublisherURL=https://github.com/chrischtel/GameBird
AppSupportURL=https://github.com/chrischtel/GameBird/issues
AppUpdatesURL=https://github.com/chrischtel/GameBird/releases
DefaultDirName={autopf}\GameBird
DefaultGroupName=GameBird
AllowNoIcons=yes
LicenseFile=LICENSE
OutputDir=Output
OutputBaseFilename=GameBird-v0.1.0-Setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "build\GameBird.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\*.dll"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "build\platforms\*"; DestDir: "{app}\platforms"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "build\qml\*"; DestDir: "{app}\qml"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "build\translations\*"; DestDir: "{app}\translations"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "README.md"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\GameBird"; Filename: "{app}\GameBird.exe"
Name: "{group}\{cm:UninstallProgram,GameBird}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\GameBird"; Filename: "{app}\GameBird.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\GameBird.exe"; Description: "{cm:LaunchProgram,GameBird}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: filesandordirs; Name: "{userappdata}\GameBird"