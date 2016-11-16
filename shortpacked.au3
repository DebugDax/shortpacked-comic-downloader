#include <inet.au3>
#include <string.au3>

$url = 'http://www.shortpacked.com/index.php?id='
Global $i = 1

DirCreate(@ScriptDir & "\comics")

While $i < 2196
	TraySetToolTip("Shortpacked" & @CRLF & $i & "...")
	$source = _INetGetSource($url & $i, True)
	If StringInStr($source, "No Comic") Then
		ConsoleWrite("Skipping: " & $i)
		$i = $i + 1
	Else
		If StringInStr($source, 'id="comic"') Then
			$data = _StringBetween($source, '<div id="comicbody">', 'id="comic"')
			If IsArray($data) Then
				$img = _StringBetween($data[0], 'http://', '"')
				If IsArray($img) Then
					$name = _StringBetween($img[0], "comics/", ".")
					If IsArray($name) Then
						$ext = StringRight($img[0], 4)
						$name[0] = StringReplace($name[0], "/", " ")
						$name[0] = StringReplace($name[0], "\", " ")
						$name[0] = StringReplace($name[0], "&", "")
						$name[0] = StringReplace($name[0], "*", "")
						$name[0] = StringReplace($name[0], "?", "")
						$name[0] = StringReplace($name[0], ")", "")
						$name[0] = StringReplace($name[0], "(", "")
						If Not FileExists(@ScriptDir & "\comics\" & $i & " " & $name[0] & $ext) Then
							ConsoleWrite($i & ": " & $name[0] & $ext & @CRLF)
							InetGet('http://' & $img[0], @ScriptDir & "\comics\" & $i & " " & $name[0] & $ext, 3, 0)
						Else
							ConsoleWrite('Skipping: ' & $i & @CRLF)
						EndIf
					Else
						ConsoleWrite('Skipping: ' & $i & @CRLF)
					EndIf
				EndIf
			EndIf
		Else
			ConsoleWrite('Skipping: ' & $i & @CRLF)
		EndIf
	EndIf
	$i = $i + 1
	;sleep(Random(1000,2400,1))
WEnd
