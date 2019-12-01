/*
http://download.piriform.com/ccsetup527pro.exe

http://download.ccleaner.com/ccsetup540pro.exe
http://download.ccleaner.com/ccsetup540pro.exe
http://download.ccleaner.com/be/ccsetup540_be.exe
http://download.ccleaner.com/te/ccsetup540_te.exe
http://download.piriform.com/pro/ccsetup527_pro.exe
http://download.piriform.com/te/ccsetup527_te.exe
http://download.piriform.com/be/ccsetup527_be.exe
https://www.upload.ee/files/6673635/cr-mcsuc.rar.html
http://download.piriform.com/ccsetup526pro.exe
https://raw.githubusercontent.com/MoscaDotTo/Winapp2/master/Winapp2.ini
https://raw.githubusercontent.com/MoscaDotTo/Winapp2/master/Winapp2.ini
*/
!define RELEASURL	"http://download.ccleaner.com"
!define 7Z ; Delete if setup not 7z
!define APPSIZE	"4070" # kB
!define DLVER	"xxx_pro-be-te"
!define APPVER 	"0.0.0.0"
!define APPNAME "CCleaner"
!define APP 	"CCleaner"
!define DLNAME	"CCleaner"
!define APPLANG	"32-64-bit_Multilingual_Online"
!define FOLDER	"CCleanerPortable"
!define MULTILANG ; Delete if not MultiLang
!define FINISHRUN ; Delete if not Finish pages
!define OPTIONS ; Delete if no Components
!define SOURCES ; Delete if no Sources
; !define DESCRIPTION	"PC Optimization and Cleaning" ; Delete if no AppInfo
!define INPUTBOX ; Delete if no InputBox

SetCompressor /SOLID lzma
SetCompressorDictSize 32

!include "..\_Include\Installer.nsh"
!include "LogicLib.nsh"
!include "x64.nsh"

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Albanian"
!insertmacro MUI_LANGUAGE "Arabic"
!insertmacro MUI_LANGUAGE "Armenian"
!insertmacro MUI_LANGUAGE "Belarusian"
!insertmacro MUI_LANGUAGE "Bosnian"
!insertmacro MUI_LANGUAGE "Bulgarian"
!insertmacro MUI_LANGUAGE "Catalan"
!insertmacro MUI_LANGUAGE "Croatian"
!insertmacro MUI_LANGUAGE "Czech"
!insertmacro MUI_LANGUAGE "Danish"
!insertmacro MUI_LANGUAGE "Dutch"
!insertmacro MUI_LANGUAGE "Estonian"
!insertmacro MUI_LANGUAGE "Farsi"
!insertmacro MUI_LANGUAGE "Finnish"
!insertmacro MUI_LANGUAGE "French"
!insertmacro MUI_LANGUAGE "Galician"
!insertmacro MUI_LANGUAGE "Georgian"
!insertmacro MUI_LANGUAGE "German"
!insertmacro MUI_LANGUAGE "Greek"
!insertmacro MUI_LANGUAGE "Hebrew"
!insertmacro MUI_LANGUAGE "Hungarian"
!insertmacro MUI_LANGUAGE "Indonesian"
!insertmacro MUI_LANGUAGE "Italian"
!insertmacro MUI_LANGUAGE "Japanese"
!insertmacro MUI_LANGUAGE "Korean"
!insertmacro MUI_LANGUAGE "Kurdish"
!insertmacro MUI_LANGUAGE "Latvian"
!insertmacro MUI_LANGUAGE "Lithuanian"
!insertmacro MUI_LANGUAGE "Macedonian"
!insertmacro MUI_LANGUAGE "Norwegian"
!insertmacro MUI_LANGUAGE "Polish"
!insertmacro MUI_LANGUAGE "Portuguese"
!insertmacro MUI_LANGUAGE "PortugueseBR"
!insertmacro MUI_LANGUAGE "Romanian"
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_LANGUAGE "Serbian"
!insertmacro MUI_LANGUAGE "SerbianLatin"
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "Slovak"
!insertmacro MUI_LANGUAGE "Slovenian"
!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_LANGUAGE "Swedish"
!insertmacro MUI_LANGUAGE "TradChinese"
!insertmacro MUI_LANGUAGE "Turkish"
!insertmacro MUI_LANGUAGE "Ukrainian"
!insertmacro MUI_LANGUAGE "Vietnamese"

Var InputVer
Var VER
Function nsDialogsPage
	nsDialogs::Create 1018
	Pop $0
	${NSD_CreateLabel} 0 0 100% 12u "Enter Version Number:"
	Pop $0
	${NSD_CreateText} 0 13u 100% 12u ""
	Pop $InputVer
	nsDialogs::Show
FunctionEnd
Function nsDialogsPageLeave
	${NSD_GetText} $InputVer $R0
StrCmp $R0 "" 0 +3
	MessageBox MB_ICONEXCLAMATION `You must enter a version number!`
Abort
	StrCpy $VER "$R0"
FunctionEnd

Var BRAND
Function MultiLang
Push ""
Push pro
Push "Professional Edition"
Push be
Push "Business Edition"
Push te
Push "Technician Edition"
Push A
LangDLL::LangDialog "${APPNAME} Portable Edition" "Please select application edition."
Pop $BRAND
StrCmp $BRAND "cancel" 0 +2
Abort
FunctionEnd

Section "${APPNAME} Portable 32 bit English" main
SectionIn RO
DetailPrint "Installing ${APPNAME} Portable 32 bit"

${If} ${FileExists} "$EXEDIR\ccsetup$VER_$BRAND.exe"
	nsExec::Exec `"$TEMP\${APP}PortableTemp\7z.exe" x "$EXEDIR\${APPSETUP}" -aoa -o"$TEMP\${APP}PortableTemp\${APP}Setup"`
${Else}
Call CheckConnected
	inetc::get "${RELEASURL}/$BRAND/ccsetup$VER_$BRAND.exe" "$TEMP\${APP}PortableTemp\ccsetup$VER_$BRAND.exe" /END
	Pop $0
StrCmp $0 "OK" +3
	MessageBox MB_ICONEXCLAMATION "ccsetup$VER_$BRAND.exe not found in $EXEDIR and download: $0"
	Abort
	nsExec::Exec `"$TEMP\${APP}PortableTemp\7z.exe" x "$TEMP\${APP}PortableTemp\ccsetup$VER_$BRAND.exe" -aoa -o"$TEMP\${APP}PortableTemp\${APP}Setup"`
${EndIf}

DetailPrint "Installing ${APPNAME} Portable 32 bit"


	SetOutPath "$INSTDIR"
		File "..\..\..\${FOLDER}\${APP}Portable.exe"
	SetOutPath "$INSTDIR\App\${APP}"
	; File "branding.dll"
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\${APP}.exe" "$INSTDIR\App\${APP}"
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\branding.dll" "$INSTDIR\App\${APP}"
	CreateDirectory "$INSTDIR\App\${APP}\Lang"


SectionEnd

Function .onGUIEnd
	RMDir "/r" "$TEMP\${APP}PortableTemp"

!ifdef DESCRIPTION
Call AppInfo
!endif
!ifdef SOURCES
Call Sources
	SetOutPath "$INSTDIR\Other\_Include\7-Zip"
	File "..\_Include\7-Zip\7z.exe"
	File "..\_Include\7-Zip\7z.dll"
!endif
!ifdef SOURCES & DESCRIPTION
Call SourceInfo
!endif
FunctionEnd

Section /o "${APPNAME} Portable 64 bit English" x64
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\${APP}64.exe" "$INSTDIR\App\${APP}"
SectionEnd

SectionGroup "Language"

Section /o "Albanian" albanian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1052.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Arabic" arabic
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1025.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Armenian" armenian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1067.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Belarusian" belarusian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1059.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Bosnian" bosnian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-5146.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Bulgarian" bulgarian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1026.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Catalan" catalan
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1027.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Croatian" croatian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1050.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Czech" czech
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1029.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Danish" danish
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1030.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Dutch" dutch
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1043.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Estonian" estonian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1061.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Farsi" farsi
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1065.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Finnish" finnish
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1035.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "French" french
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1036.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Galician" galician
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1110.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Georgian" georgian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1079.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "German" german
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1031.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Greek" greek
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1032.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Hebrew" hebrew
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1037.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Hungarian" hungarian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1038.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Indonesian" indonesian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1057.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Italian" italian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1040.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Japanese" japanese
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1041.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Korean" korean
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1042.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Kurdish" kurdish
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-9999.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Latvian" latvian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1062.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Lithuanian" lithuanian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1063.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Macedonian" macedonian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1071.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Norwegian" norwegian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1044.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Polish" polish
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1045.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Portuguese" portuguese
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-2070.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "PortugueseBR" portuguesebr
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1046.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Romanian" romanian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1048.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Russian" russian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1049.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Serbian" serbian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-3098.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "SerbianLatin" serbianlatin
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-2074.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "SimpChinese" simpchinese
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-2052.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Slovak" slovak
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1051.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Slovenian" slovenian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1060.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Spanish" spanish
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1034.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Swedish" swedish
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1053.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "TradChinese" tradchinese
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1028.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Turkish" turkish
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1055.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Ukrainian" ukrainian
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1058.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

Section /o "Vietnamese" vietnamese
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}Setup\Lang\lang-1066.dll" "$INSTDIR\App\${APP}\Lang"
SectionEnd

SectionGroupEnd

Section /o "Latest Winapp2" winapp2
	SetOutPath "$INSTDIR\App\DefaultData\${APP}"
	inetc::get "https://raw.githubusercontent.com/MoscaDotTo/Winapp2/master/Winapp2.ini" "$INSTDIR\App\DefaultData\${APP}\Winapp2.ini" /END
	CopyFiles /SILENT "$INSTDIR\App\DefaultData\${APP}\Winapp2.ini" "$INSTDIR\Data\${APP}\Winapp2.ini"
SectionEnd

Function Init
SectionSetFlags ${winapp2} 1

System::Call 'kernel32::GetUserDefaultLangID() i .r0'
StrCmp $0 "1052" 0 +3
SectionSetFlags ${albanian} 1
Goto langdone
StrCmp $0 "1025" 0 +3
SectionSetFlags ${arabic} 1
Goto langdone
StrCmp $0 "1067" 0 +3
SectionSetFlags ${armenian} 1
Goto langdone
StrCmp $0 "1059" 0 +3
SectionSetFlags ${belarusian} 1
Goto langdone
StrCmp $0 "5146" 0 +3
SectionSetFlags ${bosnian} 1
Goto langdone
StrCmp $0 "1026" 0 +3
SectionSetFlags ${bulgarian} 1
Goto langdone
StrCmp $0 "1027" 0 +3
SectionSetFlags ${catalan} 1
Goto langdone
StrCmp $0 "1050" 0 +3
SectionSetFlags ${croatian} 1
Goto langdone
StrCmp $0 "1029" 0 +3
SectionSetFlags ${czech} 1
Goto langdone
StrCmp $0 "1030" 0 +3
SectionSetFlags ${danish} 1
Goto langdone
StrCmp $0 "1043" 0 +3
SectionSetFlags ${dutch} 1
Goto langdone
StrCmp $0 "1061" 0 +3
SectionSetFlags ${estonian} 1
Goto langdone
StrCmp $0 "1065" 0 +3
SectionSetFlags ${farsi} 1
Goto langdone
StrCmp $0 "1035" 0 +3
SectionSetFlags ${finnish} 1
Goto langdone
StrCmp $0 "1036" 0 +3
SectionSetFlags ${french} 1
Goto langdone
StrCmp $0 "1110" 0 +3
SectionSetFlags ${galician} 1
Goto langdone
StrCmp $0 "1079" 0 +3
SectionSetFlags ${georgian} 1
Goto langdone
StrCmp $0 "1031" 0 +3
SectionSetFlags ${german} 1
Goto langdone
StrCmp $0 "1032" 0 +3
SectionSetFlags ${greek} 1
Goto langdone
StrCmp $0 "1037" 0 +3
SectionSetFlags ${hebrew} 1
Goto langdone
StrCmp $0 "1038" 0 +3
SectionSetFlags ${hungarian} 1
Goto langdone
StrCmp $0 "1057" 0 +3
SectionSetFlags ${indonesian} 1
Goto langdone
StrCmp $0 "1040" 0 +3
SectionSetFlags ${italian} 1
Goto langdone
StrCmp $0 "1041" 0 +3
SectionSetFlags ${japanese} 1
Goto langdone
StrCmp $0 "1042" 0 +3
SectionSetFlags ${korean} 1
Goto langdone
StrCmp $0 "9999" 0 +3
SectionSetFlags ${kurdish} 1
Goto langdone
StrCmp $0 "1062" 0 +3
SectionSetFlags ${latvian} 1
Goto langdone
StrCmp $0 "1063" 0 +3
SectionSetFlags ${lithuanian} 1
Goto langdone
StrCmp $0 "1071" 0 +3
SectionSetFlags ${macedonian} 1
Goto langdone
StrCmp $0 "1044" 0 +3
SectionSetFlags ${norwegian} 1
Goto langdone
StrCmp $0 "1045" 0 +3
SectionSetFlags ${polish} 1
Goto langdone
StrCmp $0 "2070" 0 +3
SectionSetFlags ${portuguese} 1
Goto langdone
StrCmp $0 "1046" 0 +3
SectionSetFlags ${portuguesebr} 1
Goto langdone
StrCmp $0 "1048" 0 +3
SectionSetFlags ${romanian} 1
Goto langdone
StrCmp $0 "1049" 0 +3
SectionSetFlags ${russian} 1
Goto langdone
StrCmp $0 "3098" 0 +3
SectionSetFlags ${serbian} 1
Goto langdone
StrCmp $0 "2074" 0 +3
SectionSetFlags ${serbianlatin} 1
Goto langdone
StrCmp $0 "2052" 0 +3
SectionSetFlags ${simpchinese} 1
Goto langdone
StrCmp $0 "1051" 0 +3
SectionSetFlags ${slovak} 1
Goto langdone
StrCmp $0 "1060" 0 +3
SectionSetFlags ${slovenian} 1
Goto langdone
StrCmp $0 "1034" 0 +3
SectionSetFlags ${spanish} 1
Goto langdone
StrCmp $0 "1053" 0 +3
SectionSetFlags ${swedish} 1
Goto langdone
StrCmp $0 "1028" 0 +3
SectionSetFlags ${tradchinese} 1
Goto langdone
StrCmp $0 "1055" 0 +3
SectionSetFlags ${turkish} 1
Goto langdone
StrCmp $0 "1058" 0 +3
SectionSetFlags ${ukrainian} 1
Goto langdone
StrCmp $0 "1066" 0 +3
SectionSetFlags ${vietnamese} 1
Goto langdone
langdone:
SectionSetSize ${albanian} 41 # kB
SectionSetSize ${arabic} 41 # kB
SectionSetSize ${armenian} 41 # kB
SectionSetSize ${belarusian} 41 # kB
SectionSetSize ${bosnian} 41 # kB
SectionSetSize ${bulgarian} 41 # kB
SectionSetSize ${catalan} 41 # kB
SectionSetSize ${croatian} 41 # kB
SectionSetSize ${czech} 41 # kB
SectionSetSize ${danish} 41 # kB
SectionSetSize ${dutch} 41 # kB
SectionSetSize ${estonian} 41 # kB
SectionSetSize ${farsi} 41 # kB
SectionSetSize ${finnish} 41 # kB
SectionSetSize ${french} 41 # kB
SectionSetSize ${galician} 41 # kB
SectionSetSize ${georgian} 41 # kB
SectionSetSize ${german} 41 # kB
SectionSetSize ${greek} 41 # kB
SectionSetSize ${hebrew} 41 # kB
SectionSetSize ${hungarian} 41 # kB
SectionSetSize ${indonesian} 41 # kB
SectionSetSize ${italian} 41 # kB
SectionSetSize ${japanese} 41 # kB
SectionSetSize ${korean} 41 # kB
SectionSetSize ${kurdish} 41 # kB
SectionSetSize ${latvian} 41 # kB
SectionSetSize ${lithuanian} 41 # kB
SectionSetSize ${macedonian} 41 # kB
SectionSetSize ${norwegian} 41 # kB
SectionSetSize ${polish} 41 # kB
SectionSetSize ${portuguese} 41 # kB
SectionSetSize ${portuguesebr} 41 # kB
SectionSetSize ${romanian} 41 # kB
SectionSetSize ${russian} 41 # kB
SectionSetSize ${serbian} 41 # kB
SectionSetSize ${serbianlatin} 41 # kB
SectionSetSize ${simpchinese} 41 # kB
SectionSetSize ${slovak} 41 # kB
SectionSetSize ${slovenian} 41 # kB
SectionSetSize ${spanish} 41 # kB
SectionSetSize ${swedish} 41 # kB
SectionSetSize ${tradchinese} 41 # kB
SectionSetSize ${turkish} 41 # kB
SectionSetSize ${ukrainian} 41 # kB
SectionSetSize ${vietnamese} 41 # kB
SectionSetSize ${x64} 6010 # kB
${If} ${RunningX64}
SectionSetFlags ${x64} 1
${Else}
${EndIf}
FunctionEnd
