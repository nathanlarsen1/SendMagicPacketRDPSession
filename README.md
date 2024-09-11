<h1>Send Magic Packet and Establish RDP Session</h1>


<h2>Description</h2>
The project consists of an AutoIt script that sends a magic packet to a Windows computer to wake it up and then establishes an RDP connection once it is available. You must edit two constants at the beginning of the code: $eMAC_Address and $eRemoteComputerAddress. The $eMAC_Address constant is the MAC address of the target interface of the computer you want to wake up and remotely access, while $eRemoteComputerAddress is the hostname or IP address of that target computer. Testing was performed on a 24-bit CIDR-addressed network. This script assumes that Wake-on-LAN is properly set up on the target computer.<br/><br/>


The script first sends the Wake-on-LAN packet to wake the computer. Then, it checks whether port 3389 is responding to traffic. If port 3389 is responding, it attempts to open a remote desktop session. If port 3389 is not available, a prompt is returned stating that the connection could not be made.


<h2>Languages and Protocols</h2>

- <b>AutoIt</b>
- <b>Wake on LAN (WOL)</b>
- <b>Remote Desktop Protocol (RDP)</b>

<h2>Environments Used </h2>

- <b>Windows 11</b>

<h2>Program walk-through:</h2>

<p align="center">
Launch the utility: <br/>
<img src="https://i.imgur.com/62TgaWL.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Select the disk:  <br/>
<img src="https://i.imgur.com/tcTyMUE.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Enter the number of passes: <br/>
<img src="https://i.imgur.com/nCIbXbg.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Confirm your selection:  <br/>
<img src="https://i.imgur.com/cdFHBiU.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Wait for process to complete (may take some time):  <br/>
<img src="https://i.imgur.com/JL945Ga.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Sanitization complete:  <br/>
<img src="https://i.imgur.com/K71yaM2.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Observe the wiped disk:  <br/>
<img src="https://i.imgur.com/AeZkvFQ.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
</p>

<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
