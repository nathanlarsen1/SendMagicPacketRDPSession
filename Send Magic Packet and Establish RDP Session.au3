;
; AutoIt Version: 3.3.14.2
; Language:       English
; Platform:       Win9x/NT
; Author:         Nathan Larsen
; Finalized:      02.15.2017 at 1000
;
; Script Function:
;	Send a magic packet to selected computer.
;

#include <MsgBoxConstants.au3>

AutoItSetOption("MustDeclareVars", 1)

; MAC address of the computer that magic packet will target
Const $eMAC_Address = "b4:2e:99:3b:ca:56"

;This is the address of the computer you are attempting to connect to.
;This can either be the IP address, the host name or FQDN of the computer.
Const $eRemoteComputerAddress = "192.168.50.2"

;********************************************************
; Check to see if remote computer address is an IP address
;********************************************************

; Create remote computer address array that will be used to check if the remote computer address is IP address
Global $aRemoteComputerAddressArray = StringSplit($eRemoteComputerAddress, ".")

; Loop though array to check if remote computer address is IP address.
Global $bIsIPaddress = True
For $i = 1 to $aRemoteComputerAddressArray[0]
	If (Not ($aRemoteComputerAddressArray[$i] > 0 AND $aRemoteComputerAddressArray[$i] < 255)) Then
		$bIsIPaddress = False
	EndIf
Next

; Set the remote computer address variable.
If $bIsIPaddress Then
	Global $sRemoteComputerIPv4_Address = $eRemoteComputerAddress
Else
	; Start the TCP service.
	TCPStartup()

	Global $sRemoteComputerIPv4_Address = TCPNameToIP($eRemoteComputerAddress)
    If @error Then
        MsgBox($MB_SYSTEMMODAL, "TCPNameToIP", "Error code: " & @error)
		TCPShutdown() ; Close the TCP service.
		Exit ; Exit script
	Else
		TCPShutdown() ; Close the TCP service.
    EndIf
EndIf

;********************************************************
; Run WMI query to get local IPv4 address to use it to derive the IPv4 broadcast address
;********************************************************

; Run WMI query to get network adapter information.
Global $objWMIService = ObjGet("winmgmts:\\.\root\cimv2")
Global $colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled=True", "WQL", 48)

; Loop through adapter addresses to get local IPv4 address.
Global $objItem
Global $sLocal_IPv4_Address
For $objItem In $colItems
	$sLocal_IPv4_Address = $objItem.IPAddress[0]
Next

; Create local IPv4 address array.
Global $aLocal_IPv4_AddressArray = StringSplit($sLocal_IPv4_Address, ".")

; Create IPv4 broadcast address variable.
Global $sIPv4_Broadcast_Address = $aLocal_IPv4_AddressArray[1] & "." & $aLocal_IPv4_AddressArray[2] & "." & $aLocal_IPv4_AddressArray[3] & "." & "255"

;********************************************************
; Create magic packet
;********************************************************

; Create Syncronization Stream using ASCII characters.
Global $sSyncStream = ""
For $i = 1 to 6
	$sSyncStream &= Chr(Dec("FF"))
Next

; Create MAC Byte Array.
Global $aMAC_Byte_Array = StringSplit($eMAC_Address, ":-")

; Convert MAC Byte Array into ASCII characters.
Global $sMacDecChr = ""
For $i = 1 to $aMAC_Byte_Array[0]
	$sMacDecChr &= Chr(Dec($aMAC_Byte_Array[$i]))
Next

; Create Target MAC Block.
Global $sTarget_MAC_Block = ""
For $i = 1 to 16
	$sTarget_MAC_Block &= $sMacDecChr
Next

; Create Magic Packet by concatenating the Sync Stream and the Target MAC Block.
Global $sMagicPacket = $sSyncStream & $sTarget_MAC_Block

;********************************************************
; Use UDP service to send magic packet
;********************************************************

; Start the UDP service.
UDPStartUp()

; Send Magic Packet to broadcast address.
Global $iUDP_Socket = UDPOpen($sIPv4_Broadcast_Address, 7)
UDPSend($iUDP_Socket, $sMagicPacket)

; Close the socket.
UDPCloseSocket($iUDP_Socket)

; Close the UDP service.
UDPShutdown()

;********************************************************
; Test connection with computer and establish an RDP session if connection is established
;********************************************************

; Port used for RDP connection
 Global $iRDP_Port = 3389

; Invoke message box informing of connection attempt with remote computer.
MsgBox(BitOR($MB_SYSTEMMODAL, $MB_ICONINFORMATION), "", "Attempting to establish a connection with remote computer.", 3)

; Start the TCP service.
TCPStartup()

; Set length of each TCP timeout in milliseconds.
Opt("TCPTimeout", 5000)

; Number of attempts to see if RDP socket is open on remote computer.
Global $iAttemptCount = 12

; Create variable to store status of connection attempt to RDP socket on remote computer.
Global $iTCP_Socket = 0

; Create loop to give time for remote computer to become available.
While 1
	; Check if RDP socket on the remote computer is open.
	$iTCP_Socket = TCPConnect($sRemoteComputerIPv4_Address, $iRDP_Port)

	If $iTCP_Socket = -1 Then ; Timeout occurred
		$iAttemptCount -= 1
		If $iAttemptCount < 0 Then
			; Invoke message box due to maximum number of attempts being reached. The remote computer is either offline or the socket is not open on the remote computer.
			MsgBox(BitOR($MB_SYSTEMMODAL, $MB_ICONERROR), "TCPConnect", "Was not able to establish a connection with " & $eRemoteComputerAddress & ", after maximum number of attempts was reached.")
			ExitLoop
		EndIf
	Else
		; Open Remote Desktop Connection if RDP socket was found to be open on the remote computer.
		Run("mstsc.exe /v:" & $eRemoteComputerAddress, "", @SW_SHOWMAXIMIZED)
		ExitLoop
	EndIf

WEnd

; Close the socket.
TCPCloseSocket($iTCP_Socket)

; Close the TCP service.
TCPShutdown()