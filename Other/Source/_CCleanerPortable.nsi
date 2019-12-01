
; **************************************************************************
; === Define constants ===
; **************************************************************************
!define VER 		"0.0.0.0"	; version of launcher
!define APPNAME 	"CCleaner Professional"	; complete name of program
!define APP 		"CCleaner"	; short name of program without space and accent  this one is used for the final executable an in the directory structure
!define APPEXE 		"CCleaner.exe"	; main exe name
!define APPEXE64 	"CCleaner64.exe"	; main exe 64 bit name
!define APPDIR 		"App\CCleaner"	; main exe relative path
!define APPDIR64 	"App\CCleaner"	; main exe 64 bit relative path
!define APPSWITCH 	``	; some default Parameters

; **************************************************************************
; === Best Compression ===
; **************************************************************************
SetCompressor /SOLID lzma
SetCompressorDictSize 32

; **************************************************************************
; === Includes ===
; **************************************************************************
!include "..\_Include\Launcher.nsh" 
!include "LogicLib.nsh"
!include "x64.nsh"

; **************************************************************************
; === Set basic information ===
; **************************************************************************
Name "${APPNAME} Portable"
OutFile "..\..\..\${APP}Portable\${APP}Portable.exe"
Icon "${APP}.ico"

; **************************************************************************
; ==== Running ====
; **************************************************************************

Section "Main"

	Call CheckStart

	Call Init

		Call SplashLogo
		Call Launch

	Call Restore

SectionEnd

Function Restore

	Call Close

FunctionEnd

; **************************************************************************
; === Other Actions ===
; **************************************************************************
Function Init
; Force to use ini by creating portable.dat
	FileOpen $0 "$EXEDIR\${APPDIR}\portable.dat" w
	FileWrite $0 "#PORTABLE#"
	FileClose $0
; Move CCleaner.ini from Data to program folder
	Rename "$EXEDIR\Data\${APP}\${APP}.ini" "$EXEDIR\${APPDIR}\${APP}.ini"

	WriteINIStr "$EXEDIR\${APPDIR}\${APP}.ini" "Options" "BrowserMonitoring" "0"
	WriteINIStr "$EXEDIR\${APPDIR}\${APP}.ini" "Options" "SystemMonitoring" "0"
	WriteINIStr "$EXEDIR\${APPDIR}\${APP}.ini" "Options" "RunICS" "0"

; Move Winapp2.ini from Data to program folder or copy default
	IfFileExists "$EXEDIR\Data\${APP}\Winapp2.ini" +3
	CreateDirectory "$EXEDIR\Data\${APP}"
	CopyFiles /SILENT "$EXEDIR\App\DefaultData\${APP}\Winapp2.ini" "$EXEDIR\Data\${APP}\Winapp2.ini"
	Rename "$EXEDIR\Data\${APP}\Winapp2.ini" "$EXEDIR\${APPDIR}\Winapp2.ini"
; Set Language in CCleaner.ini
	ReadINIStr $0 "$EXEDIR\${APP}Portable.ini" "${APP}Portable" "UserDefaultLang"
	StrCmp $0 "false" +4
	WriteINIStr "$EXEDIR\${APP}Portable.ini" "${APP}Portable" "UserDefaultLang" "true"
	System::Call 'kernel32::GetUserDefaultLangID() i .r0'
	WriteINIStr "$EXEDIR\${APPDIR}\${APP}.ini" "Options" "Language" "$0"
; Set BackupDir
	ReadINIStr $0 "$EXEDIR\${APP}Portable.ini" "${APP}Portable" "PortableBackupDir"
	StrCmp $0 "false" +4
	WriteINIStr "$EXEDIR\${APP}Portable.ini" "${APP}Portable" "PortableBackupDir" "true"
	CreateDirectory "$EXEDIR\Backups"
	WriteINIStr "$EXEDIR\${APPDIR}\${APP}.ini" "Options" "BackupDir" "$EXEDIR\Backups"
; Register
	SetOutPath "$EXEDIR\${APPDIR}"
	File "${APP}.dat"
FunctionEnd

Function Close
; Turn back settings to Data
	CreateDirectory "$EXEDIR\Data\${APP}"
	Rename "$EXEDIR\${APPDIR}\${APP}.ini" "$EXEDIR\Data\${APP}\${APP}.ini"
	Rename "$EXEDIR\${APPDIR}\Winapp2.ini" "$EXEDIR\Data\${APP}\Winapp2.ini"
; UnRegister
Delete "$EXEDIR\${APPDIR}\${APP}.dat"

FunctionEnd

; **************************************************************************
; === Run Application ===
; **************************************************************************
Function Launch
${GetParameters} $0
${If} ${RunningX64}
${AndIf} ${FileExists} "$EXEDIR\${APPDIR64}\${APPEXE64}"
SetOutPath "$EXEDIR\${APPDIR64}"
ExecWait `"$EXEDIR\${APPDIR64}\${APPEXE64}"${APPSWITCH} $0`
${Else}
SetOutPath "$EXEDIR\${APPDIR}"
ExecWait `"$EXEDIR\${APPDIR}\${APPEXE}"${APPSWITCH} $0`
${EndIf}
WriteINIStr "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "GoodExit" "true"
newadvsplash::stop
FunctionEnd

