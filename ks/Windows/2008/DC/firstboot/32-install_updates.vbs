Sub Pause(strPause)
     WScript.Echo (strPause)
     z = WScript.StdIn.Read(1)
End Sub

WScript.Echo "Time is: " & Now

Set objProxy = CreateObject("Microsoft.Update.WebProxy")
objProxy.AutoDetect = False
objProxy.Address = "http://kpCloud-ks:8000"
objProxy.UserName = ""
objProxy.SetPassword("")
objProxy.BypassProxyOnLocal = True

Set colBypass = CreateObject("Microsoft.Update.StringColl")
colBypass.Add("")
objProxy.BypassList = colBypass

Set updateSession = CreateObject("Microsoft.Update.Session")
updateSession.ClientApplicationID = "MSDN Sample Script"
'Uncommet below if specifying a real forward proxy server; a real
'forward proxy server is one that supports CONNECT method, which 
'WinHTTP requires
'updateSession.WebProxy = objProxy

Set updateSearcher = updateSession.CreateUpdateSearcher()

WScript.Echo "Searching for updates..." & vbCRLF

Set searchResult = _
updateSearcher.Search("IsInstalled=0 and IsHidden=0")
'updateSearcher.Search("IsInstalled=0 and Type='Software' and IsHidden=0")

WScript.Echo "List of applicable items on the machine:"

For I = 0 To searchResult.Updates.Count-1
    Set update = searchResult.Updates.Item(I)
    WScript.Echo I + 1 & "> " & update.Title
Next

If searchResult.Updates.Count = 0 Then
    WScript.Echo "There are no applicable updates."
    WScript.Echo "Time is: " & Now
    WScript.Quit
End If

WScript.Echo vbCRLF & "Creating collection of updates to download:"
WScript.Echo "Time is: " & Now

Set updatesToDownload = CreateObject("Microsoft.Update.UpdateColl")

For I = 0 to searchResult.Updates.Count-1
    Set update = searchResult.Updates.Item(I)
    WScript.Echo I + 1 & "> adding: " & update.Title 
    updatesToDownload.Add(update)
    If update.EulaAccepted = False Then 
        update.AcceptEula
        WScript.Echo I + 1 & ">     Accept EULA " & update.Title 
    End If
Next

If updatesToDownload.Count = 0 Then
    WScript.Echo "All applicable updates were skipped."
    WScript.Echo "Time is: " & Now
    WScript.Quit
End If
    
WScript.Echo vbCRLF & "Downloading updates..."
WScript.Echo "Time is: " & Now

Set downloader = updateSession.CreateUpdateDownloader() 
downloader.Updates = updatesToDownload
downloader.Download()

Set updatesToInstall = CreateObject("Microsoft.Update.UpdateColl")

rebootMayBeRequired = false

WScript.Echo vbCRLF & "Successfully downloaded updates:"

For I = 0 To searchResult.Updates.Count-1
    set update = searchResult.Updates.Item(I)
    If update.IsDownloaded = true Then
        WScript.Echo I + 1 & "> " & update.Title 
        updatesToInstall.Add(update) 
        If update.InstallationBehavior.RebootBehavior > 0 Then
            rebootMayBeRequired = true
        End If
    End If
Next

If updatesToInstall.Count = 0 Then
    WScript.Echo "No updates were successfully downloaded."
    WScript.Echo "Time is: " & Now
    WScript.Quit
End If

WScript.Echo "Installing updates..."
Set installer = updateSession.CreateUpdateInstaller()
installer.Updates = updatesToInstall
Set installationResult = installer.Install()

'Output results of install
WScript.Echo "Installation Result: " & _
installationResult.ResultCode 
WScript.Echo "Reboot Required: " & _ 
installationResult.RebootRequired & vbCRLF 
WScript.Echo "Listing of updates installed " & _
"and individual installation results:" 

For I = 0 to updatesToInstall.Count - 1
    WScript.Echo I + 1 & "> " & _
    updatesToInstall.Item(i).Title & _
    ": " & installationResult.GetUpdateResult(i).ResultCode   
Next

WScript.Echo "Time is: " & Now

'
'Set OpSysSet = GetObject("winmgmts:{authenticationlevel=Pkt," _
'     & "(Shutdown)}").ExecQuery("select * from Win32_OperatingSystem where "_
'     & "Primary=true")
'for each OpSys in OpSysSet
'    retVal = OpSys.Reboot()
'next
'
'Pause("Waiting for reboot ...")
'

WScript.Quit 255
