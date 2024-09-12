<h1>Send Magic Packet and Establish RDP Session</h1>


<h2>Description</h2>
This project consists of an AutoIt script that sends a magic packet to a Windows computer to wake it up and then establishes an RDP connection once it is available. You must edit two constants at the beginning of the code: $eMAC_Address and $eRemoteComputerAddress. The $eMAC_Address constant is the MAC address of the target interface of the computer you want to wake up and remotely access, while $eRemoteComputerAddress is the hostname or IP address of that target computer. Testing was performed on a 24-bit CIDR-addressed network. This script assumes that Wake-on-LAN is properly set up on the target computer.<br/><br/>


The script first sends the Wake-on-LAN packet to wake the computer. Then, it checks whether port 3389 is responding to traffic. If port 3389 is responding, it attempts to open a remote desktop session. If port 3389 is not available, a prompt is returned stating that the connection could not be made.


<h2>Languages and Protocols</h2>

- <b>AutoIt</b>
- <b>Wake on LAN (WOL)</b>
- <b>Remote Desktop Protocol (RDP)</b>

<h2>Environments Used </h2>

- <b>Windows 11</b>

<h2>Program walk-through:</h2>

<p align="center">
Connection Attempt: <br/>
<img src="https://i.imgur.com/1uxF1V9.png" height="80%" width="80%" alt="Connection Attempt"/>
<br />
<br />
RDP Login Prompt:  <br/>
<img src="https://i.imgur.com/dP79sB2.png" height="80%" width="80%" alt="RDP Login Prompt"/>
<br />
<br />
Unable to Connect Error: <br/>
<img src="https://i.imgur.com/gPbNMbw.png" height="80%" width="80%" alt="Unable to Connect"/>
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
