@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

:
:' Written in 2007 by Harry Johnston, University of Waikato, New Zealand.
:' This code has been placed in the public domain.  It may be freely
:' used, modified, and distributed.  However it is provided with no
:' warranty, either express or implied.
:'
:' Exit Codes:
:'   0 = scripting failure
:'   1 = error obtaining or installing updates
:'   2 = installation successful, no further updates to install
:'   3 = reboot needed; rerun script after reboot
:'
:' Note that exit code 0 has to indicate failure because that is what
:' is returned if a scripting error is raised.
:'
:
:Set updateSession = CreateObject("Microsoft.Update.Session")
:
:Set updateSearcher = updateSession.CreateUpdateSearcher()
:Set updateDownloader = updateSession.CreateUpdateDownloader()
:Set updateInstaller = updateSession.CreateUpdateInstaller()
:
:Do
:
:  Set updateSearch = updateSearcher.Search("IsInstalled=0")
:
:  If updateSearch.ResultCode <> 2 Then
:
:    WScript.Quit 1
:
:  End If
:
:  If updateSearch.Updates.Count = 0 Then
:
:    WScript.Quit 2
:
:  End If
:
:  Set updateList = updateSearch.Updates
:
:  For I = 0 to updateSearch.Updates.Count - 1
:
:    Set update = updateList.Item(I)
:
:  Next
:
:  updateDownloader.Updates = updateList
:  updateDownloader.Priority = 3
:
:  Set downloadResult = updateDownloader.Download()
:
:  If downloadResult.ResultCode <> 2 Then
:
:    WScript.Quit 1
:
:  End If
:
:  updateInstaller.Updates = updateList
:
:  Set installationResult = updateInstaller.Install()
:
:  If installationResult.ResultCode <> 2 Then
:
:    For I = 0 to updateList.Count - 1
:
:      Set updateInstallationResult = installationResult.GetUpdateResult(I)
:
:    Next
:
:    WScript.Quit 1
:
:  End If
:
:  If installationResult.RebootRequired Then
:
:    WScript.Quit 3
:
:  End If
:
:Loop 
:

findstr /B ":" "%~sf0" >update.vbs 
%ComSpec% /c %SystemRoot%\System32\cscript.exe //nologo update.vbs

exit 0

