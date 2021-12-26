regsvr32.exe /u %~dp0posdevices.wsc /s
regsvr32.exe /u %~dp0scoding.wsc /s
regsvr32.exe /u %~dp0mscomm32.ocx /s
netsh wlan stop hostednetwork
netsh wlan set hostednetwork disallow

