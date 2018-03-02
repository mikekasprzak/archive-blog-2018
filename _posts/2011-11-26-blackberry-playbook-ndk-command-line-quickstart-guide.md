---
id: 4720
title: BlackBerry PlayBook NDK Command Line Advanced Quickstart Guide
date: 2011-11-26T22:32:08+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=4720
permalink: /2011/11/26/blackberry-playbook-ndk-command-line-quickstart-guide/
categories:
  - Technobabble
---
[Phil](http://www.galcon.com) keeps telling me I need to document what I do. After all, I&#8217;ve worked on a ridiculous number of platforms, and with many SDK&#8217;s.

So alright, I&#8217;m going to record and share my notes here. I&#8217;m going to assume you have your own build system figured out, and cover the highlights and key things you need to know and do to get native code up and running on the PlayBook.

### Device Summary

Just a few highlights about the platform.

  * Dual Core 1 GHz ARM Coretex-A9 w/ Neon, 7&#8243; 1024&#215;600 IPS LCD (drool), PowerVR SGX 540 GPU
  * NDK Available. Work either through a custom Eclipse IDE, or entirely from the command line
  * Command line is a typical GCC cross compiler setup, with custom tools for packaging/deploying
  * Linux-like platform. EGL and GLES1/GLES2 available. OpenAL available ([Notes](http://www.codedojo.com/?p=1439))
  * BlackBerry packages are BAR files, which are actually JAR files, which are actually ZIP files
  * Was on sale for just $199 during the weeks surrounding &#8220;Black Friday&#8221;.

### Step 1. Request Signing Keys

This is step 1 because how long it takes is entirely outside your control.

Go to <http://developer.blackberry.com/native/signingkey> ([ALT](https://www.blackberry.com/SignedKeys/)) and make your request. Typically within a few hours you will get a series of e-mails containing **.csj** files, so if you&#8217;ve previously downloaded the SDK, you&#8217;ll be waiting a while before you can test on device. More details [here](https://bdsc.webapps.blackberry.com/native/documentation/com.qnx.doc.native_sdk.quickstart/topic/request_code_sign_key.html).

**IMPORTANT:** REMEMBER YOUR PIN AND COMPANY NAME! YOU WILL NEED IT!

For times like these, I like to create a text file containing the signing code, and put it alongside the signing keys. Yes, technically that partially defeats the security purpose of the keys, but keys and signing is usually such-a-pain.

### Step 1b. Apply for a Blackberry AppWorld Vendor account

This also takes a while, so do this early to get in the queue sooner.

<https://appworld.blackberry.com/isvportal/>

You will eventually get an email asking for a scan of government issued ID such as a drivers license, or business related documents (to prove you are real). If you have these ready, you can respond to the request quickly.

Payments are via Paypal, so you will need a valid Paypal account to be paid.

### Step 2. Get the NDK

Yeah! You can do it! Click them links and go go go!

<https://bdsc.webapps.blackberry.com/native/>

Notably, the downloader tries to install some Akamai service thingy. I couldn&#8217;t get this working, but that&#8217;s okay. There&#8217;s an option to say &#8220;**this did not work**&#8221; in the popup box, and after the popup closes there&#8217;s an option to download directly without Akamai. Use it.

<!--more-->

### Step 3. Install the NDK

PSA: **RIGHT CLICK AND RUN INSTALLER AS ADMIN!!**

After installation, a batch file and shell script can be found in the install folder that contains all paths.

> **C:\bbndk-1.0\**bbndk-env.bat

The batch file, by default, does not bring up a shell. It simply correctly sets the environment variables.

Me, I made a copy of the batch file (now **bbndk-env-shell.bat**), and simply added a line &#8220;**cmd**&#8221; to the end of the file. Now I have a shell.

One further addition I made was adding MinGW&#8217;s MSys to the path. I rely on Unix tools like **readlink** and **basename** in some of my shell scripts, and the simplest way for me to get access to these was to just use the ones that ship with MinGW. If you&#8217;re not as Unix&#8217;y as I am, simply adding &#8220;**cmd**&#8221; will be enough to build the any of the example programs using make.

My complete script (bbndk-env-shell.bat) is as follows.

> <pre>REM This script is sets environment variables requires to use this version of NDK
REM from the command line.
REM bbndk-env.bat
REM

set QNX_TARGET=C:/bbndk-1.0/target/qnx6
set QNX_HOST=C:/bbndk-1.0/host/win32/x86
set QNX_CONFIGURATION=C:\Users\mike\AppData\Local\Research In Motion\BlackBerry Native SDK
set MAKEFLAGS=-I%QNX_TARGET%/usr/include
set PATH=%QNX_HOST%\usr\bin;%QNX_CONFIGURATION%\bin;%QNX_HOST%\usr\qde\eclipse\jre\bin;%PATH%

REM So I can have readlink and basename (used by TreeTool.sh)
set PATH=C:\MinGW\msys\1.0\bin;%PATH%

cmd</pre>

Alternatively, if you&#8217;d prefer to work inside bash, you can use &#8220;**bash -l**&#8221; instead of &#8220;**cmd**&#8220;.

### Step 4. Create Signing Tokens

I used [this](http://www.drmop.com/index.php/2011/08/30/marmalade-sdk-and-blackberry-playbook-from-setup-and-deployment-to-app-world-submission/) for reference.

By now you have hopefully received your signing keys from RIM. If not, go get coffee&#8230; then Pizza&#8230; then watch a movie. Once you do get them, put them somewhere safe. I like to bundle them inside my source tree, in a platform specific place. That way, I have a copy on all PCs that sync my source repository.

Browse to your keys folder.

Execute the following **four** commands to set up your signing account.

> <pre>blackberry-keytool -genkeypair -storepass {PASSWORD} -dname "cn={MY_COMPANY}" -alias author

blackberry-signer -csksetup -cskpass {PASSWORD}

blackberry-signer -register -csjpin {PIN} -cskpass {PASSWORD} client-RDK-????????.csj

blackberry-debugtokenrequest -register -cskpass {PASSWORD} -csjpin {PIN} client-PBDT-????????.csj</pre>

Where **{PASSWORD}** is a unique password you will remember, **{MY_COMPANY}** is the company name used when you signed up for your keys, **{PIN}** is the unique code you picked when you signed up for your keys, and **client-RDK-????????.csj/client-PBDT-????????.csj** the the name of your RDK and PBDT key files respectfully.

(NOTE TO SELF: I used to set -keystore author.p12 on the command line, like my reference suggested, but I&#8217;m hoping by omitting this it works too. Explicitly setting keystore wouldn&#8217;t create author.p12 inside the settings folder. Moving to another computer, for whatever reason, would only work if the .p12 file was alongside the settings, and not explicitly via the command line)

### Step 5. Create a provisioning token for our device

We need to request a token (BAR file) to provision each of our devices.

> `blackberry-debugtokenrequest -cskpass {PASSWORD} -storepass {PASSWORD} -deviceId {HEX_DEVICE_PIN} mydebugtoken.bar`

**{PASSWORD}** is used twice (well, it can be different but that would be annoying). **{HEX\_DEVICE\_PIN}** should be your device PIN in a format like **0xABCD1234** (found under Settings->About->Hardware->PIN, and **mydebugtoken.bar** is the BAR file we&#8217;ll be writing.

### Step 6. Installing the provisioning token on our device

To install the provisioning token (BAR file), you need the **IP address** of the device. Get this from **Settings->About->Networking**.

Next, you need to enable developer mode and to actually send the token via WIFI. Go to **Settings->Security->Development Mode** be sure **Use Development Mode** is On. You may have to do this <span style="text-decoration: underline;">every time you reboot the device</span>.

We send the debug token to device by doing the following:

> `blackberry-deploy -installDebugToken mydebugtoken.bar -device {DEVICE_IP} -password {DEVICE_PASSWORD}`

Where **{DEVICE_IP}** is the devices IP address on your network, and **{DEVICE_PASSWORD}** is the password set when you first enabled developer mode (or if you set a password).

<font color="#ff00ff">NOTE:</font> You&#8217;ll need to generate a new provisioning (debug) token every 10 days (Step 5), and send it to the device (Step 6). You can check the status of the token in the Security->Development Mode section of Settings.

Phew!

Now we are ready to send our own binaries to the device. Great! But how do we make one?

### Step 7. Compiling Code

GCC and all the tools used above can be found in &#8220;**C:\bbndk-1.0\host\win32\x86\usr\bin**&#8220;. The PlayBook is an ARM based device, so we need to invoke the correct GCC build.

  * GCC tools (gcc, g++) prefixed with **ntoarmv7-** are your Native PlayBook compilers (ntoarmv7-g++)
  * GCC tools (gcc, g++) prefixed with **ntox86-** are your Simulator compilers (ntox86-g++)
  * Alternatively, a tool exists &#8220;**qcc**&#8221; for [QNX GCC](https://bdsc.webapps.blackberry.com/native/documentation/com.qnx.doc.neutrino.utilities/topic/q/qcc.html), which acts as a frontend to the above tools. The C++ version is **QCC** (caps).

GNU Make, Bash, and a plethora of other typical Unix tools are included as well. Omitted are some of more Unix specific ones like readlink and basename, but if you have [MinGW+MSys](http://www.mingw.org) installed, you can add them easily (see Step 3).

The BlackBerry command-line tools (batch files and shell scripts) include:

  * **blackberry-airpackager** &#8211; Make Adobe Air Apps BAR packages
  * **blackberry-connect** &#8211; Allow SSH access
  * **blackberry-debugtokenrequest** &#8211; Used to get us a token (see above)
  * **blackberry-deploy** &#8211; Send a BAR package (apps) to a device
  * **blackberry-keytool** &#8211; Used to generate keys (see above)
  * **blackberry-nativepackager** &#8211; Make BAR packages for deployment
  * **blackberry-pythonpackager** &#8211; Hey neat, apparently you can do Python
  * **blackberry-signer** &#8211; Sign BAR packages
  * **blackberry-uripackager** &#8211; Make BAR packages that are a URL

The batch files and shell scripts are merely frontends. In actuality, the tools are all Java based.

For reference, Library files can be found in:

> `C:\bbndk-1.0\target\qnx6\armle-v7\lib<br />
C:\bbndk-1.0\target\qnx6\armle-v7\usr\lib<br />
C:\bbndk-1.0\target\target-override\armle-v7\lib **<br />
C:\bbndk-1.0\target\target-override\armle-v7\usr\lib **`

Header files can be found in:

> `C:\bbndk-1.0\target\qnx6\usr\include<br />
C:\bbndk-1.0\target\target-override\usr\include **`

The libraries in the paths above with ** need to be explicitly added to your include paths and library search paths (-I and -L).

### Step 8. Library Linking Notes

Not actually a step, but you&#8217;re going to need to link against some libraries to get access to any useful features of the device. I&#8217;m going to assume you know how to link a program with GCC/G++, and how to specify libraries (-l).

**Very important**, you need to add the Target Overrides to your include and library search paths (-I and -L). If you don&#8217;t, older versions of the libraries will be referenced. This is bad because RIM changed the names and argument counts of some functions (Navigator library functions used to be nav_ prefixed, but are now navigator_ prefixed). I made this silly mistake of omitting this, and got totally confused, as the documentation suggests different names. The correct function names are available with the overrides.

> `-I$(QNX_TARGET)/../target-override/usr/include`

And the library paths:

> `-L$(QNX_TARGET)/../target-override/$(CPUVARDIR)/lib<br />
-L$(QNX_TARGET)/../target-override/$(CPUVARDIR)/usr/lib`

If you&#8217;re using the **bbutil.h** and **bbutil.c** files included with the sample apps, be sure to include FreeType in your include paths (unless you&#8217;d rather fix the file):

> `-I$(QNX_TARGET)/usr/include/freetype2`

As well, add the Freetype and libPNG libraries to your project.

> `-lfreetype -png</p></blockquote>
<p><strong>TIP</strong>: If you're developing a game that uses OpenGL ES 2, and you want to use <strong>bbutil.h</strong> and <strong>.c</strong>, you'll have to modify (or comment out) parts of the font code, as it relies on some OpenGL ES 1 calls.</p>
<p>PlayBook features many standard libraries including:</p>
<ul>
<li>EGL 1.4 (OpenGL Contexts): <strong>-lEGL</strong> (libEGL.a), /usr/include/EGL/</li>
<li>OpenGL ES 1.1: <strong>-lGLES_CM</strong> (libGLES_CM.a) or <strong>-lGLESv1_CM</strong> (libGLESv1_CM.a), /usr/include/GLES/</li>
<li>OpenGL ES 2.0: <strong>-lGLESv2</strong> (libGLESv2.a), /usr/include/GLES2/</li>
<li>Lib Curl (simple HTTP fetching): <strong>-lcurl</strong> (libcurl.a), /usr/include/curl/</li>
<li>zlib (gzip compression): <strong>-lz</strong> (libz.a), /usr/include/zlib.h</li>
<li>Lib PNG (PNG Image Read/Write): <strong>-lpng</strong> (libpng.a), /usr/include/libpng/</li>
<li>Open SSL (Security): <strong>-lssl</strong> (libssl.a), /usr/include/openssl/</li>
</ul>
<p>More details can be <a href="https://bdsc.webapps.blackberry.com/native/documentation/com.qnx.doc.native_sdk.devguide/com.qnx.doc.native_sdk.devguide/topic/libraries.html">found here</a>, as well as a complete list of PlayBook libraries <a href="https://bdsc.webapps.blackberry.com/native/reference">can be found here</a>.</p>
<p>(<strong>NOTE:</strong> Every library has a version with a trailing capitol S (libEGLS.a, libcurlS.a, etc). These are apparently something to do with relocatable code. <a href="http://supportforums.blackberry.com/t5/Native-SDK-for-BlackBerry-Tablet/What-are-the-Library-files-with-quot-S-quot/m-p/1436419/highlight/true#M589">Details here</a>. Where this is useful, I have no idea. I can build binaries fine without it.)</p>
<h3>Step 9. Preparing bar-descriptior.xml</h3>
<p>Before we can deploy to the device, we need to package it. Before we can package it, we need to provide some details for the packager. We do this inside a file <strong>bar-descriptor.xml</strong>.</p>
<p>The easiest way to make a <strong>bar-descriptor.xml</strong> is to steal it from <a href="https://bdsc.webapps.blackberry.com/native/sampleapps">one of the sample programs</a>, such as HelloNativeSDK.</p>
<p>This file is well documented, so go in and adjust it to suit your needs.</p>
<p>Well, everything except these.</p>
<blockquote>
<pre><configuration id="com.qnx.qcc.toolChain.489051119" name="Default">
	<platformArchitecture>armle-v7</platformArchitecture>
	<asset path="arm/o.le-v7-g/HelloNativeSDKMakefile" entry="true" type="Qnx/Elf">HelloNativeSDKMakefile</asset>
</configuration>
<configuration id="com.qnx.qcc.toolChain.41237944" name="Device-Debug">
	<platformArchitecture>armle-v7</platformArchitecture>
	<asset path="arm/o.le-v7-g/HelloNativeSDKMakefile" entry="true" type="Qnx/Elf">HelloNativeSDKMakefile</asset>
</configuration>
<configuration id="com.qnx.qcc.toolChain.509616336" name="Device-Release">
	<platformArchitecture>armle-v7</platformArchitecture>
	<asset path="arm/o.le-v7/HelloNativeSDKMakefile" entry="true" type="Qnx/Elf">HelloNativeSDKMakefile</asset>
</configuration>
<configuration id="com.qnx.qcc.toolChain.844439800" name="Simulator">
	<platformArchitecture>x86</platformArchitecture>
	<asset path="x86/o-g/HelloNativeSDKMakefile" entry="true" type="Qnx/Elf">HelloNativeSDKMakefile</asset>
</configuration></pre>
</blockquote>
<p>As it turns out, those toolchain Id's are important. Be sure they don't change.</p>
<p>Further details can be <a href="https://bdsc.webapps.blackberry.com/native/documentation/com.qnx.doc.ide.userguide/topic/capabilities_editor_options_base.html">found here</a>.</p>
<h3>Step 10. Packaging a BAR file</h3>
<p>BAR files are the native format of BlackBerry binaries. You can define the contents of the package using the bar-descriptor.xml file, or via the command line.</p>
<p><strong>NOTE:</strong> Environment Variables aren't, for whatever reason, passed to blackberry-nativepackager. I had to manually pass <strong>QNX_TARGET</strong> on the command line using <strong>-D</strong>.</p>
<blockquote><p><code>blackberry-nativepackager -package MyApp.bar -devmode bar-descriptor.xml -DQNX_TARGET=%QNX_TARGET%`

Or if a BASH shell:

> `blackberry-nativepackager -package MyApp.bar -devmode bar-descriptor.xml -DQNX_TARGET=$QNX_TARGET`

If you **did not** specify either the **Author Name** or **Author Id** inside the **bar-descriptor.xml** file, you can have blackberry-nativepackager extract them from your debug token file for you.

> `blackberry-nativepackager -package MyApp.bar -devmode -debugToken mydebugtoken.bar bar-descriptor.xml -DQNX_TARGET=%QNX_TARGET%`

Eventually, you will need to look up the Author Id. See Appendix C for a way.

A BAR file is actually a JAR file, and both BAR and JAR files are actually ZIP files. Simply rename to or append a ".zip" to the file name, and you can browse the contents using any standard archiver.

### Step 11. Installing and Launching the BAR file

It's been a long journey, but the end is finally here.

> `blackberry-deploy -installApp -device {DEVICE_IP} -password {DEVICE_PASSWORD} MyApp.bar`

**NOTE:** It's silly, but the BAR file name **must** come after the **DEVICE_IP**.

To also run the application after installing, use -launchApp.

> `blackberry-deploy -installApp -launchApp -device {DEVICE_IP} -password {DEVICE_PASSWORD} MyApp.bar`

If you really wanted to, you can also "just launch" the app by omitting "-installApp" from the above command. Everything else in the command is required.

Huh-freaking-zah! We did it!

### Step 12. SSH'ing in to a PlayBook to get Logs

I used [this](http://corlan.org/2011/01/17/making-ssh-connections-to-playbook-simulator/) as reference.

First, we need to make an RSA key for SSH. From the shell, invoke:

> `ssh-keygen -t rsa -b4096 -f MyRSAKey`

Using a passphrase is up to you.

This generates two files: **MyRSAKey** (private key) and **MyRSAKey.pub** (public key).

Next, we're ready to open an SSH connection to the PlayBook. Make sure you have developer mode enabled (**Settings->Security->Developer Mode**, swipe the slider button to on).

**NOTICE:** We are going to need **2** shells for this part.

From a new (dummy) shell, execute the following command.

> `blackberry-connect -targetHost {IP_ADDRESS} -devicePassword {DEVICE_PASSWORD} -sshPublicKey MyRSAKey.pub`

**NOTICE:** This step used the <span style="text-decoration: underline;">Public</span> key.

Finally, in your original shell, open an SSH connection as follows.

> `ssh devuser@{IP_ADDRESS} -i MyRSAKey`

**NOTICE:** This step used the _Private_ key.

Deployed applications can be found in **/apps/**.

STDOUT can be found under **/accounts/1000/appdata/{APP_NAME}/logs/** in a file "log".

{APP_NAME} will be something like "com.mycompany.MyApp.ab312938a32ddae". The exact name can be extracted from the Manifest file (see Appendix D).

**NOTE**: PlayBook logging is slightly delayed, so for accurate results in the log file, I highly recommend you call **fflush(0)** after every printf call. Yes, this slows things down, but it makes tracing remote crashes SO MUCH easier (from impossible to possible).

### Step 13. Sharing Builds with Testers

To send a build to a tester (or a friend), you need the 8 character **PIN** of their device. This can be found in **Settings->Hardware->PIN**.

With the PIN, you can generate a signing token for their device. Exactly like Step 5:

> `blackberry-debugtokenrequest -cskpass {PASSWORD} -storepass {PASSWORD} -deviceId {HEX_DEVICE_PIN} TesterDebugToken.bar`

**TIP**: Multiple DeviceID's can be added to a Provisioning Token (similar to iPhone Adhoc). Simply repeat -deviceId for each PIN.

Your application BAR file is already in developer mode (-devmode), so paired with this Debug Token file, the tester can run your game. Send them both BAR files.

Now, actually having your tester install the bar files on the device is the tricky part. If it makes sense for them to have the SDK installed, then this will be easier. However, if they are just a tester and not a developer, giving them a build can be a little clumsy.

Your tester needs a version of the **blackberry-deploy** available on their PC. If they do, simply have them bring up a shell, and execute the following.

> `blackberry-deploy -installDebugToken TesterDebugToken.bar -device {DEVICE_IP} -password {DEVICE_PASSWORD}</p>
<p>blackberry-deploy -installApp -device {DEVICE_IP} -password {DEVICE_PASSWORD} MyApp.bar`

Realistically though, a tester wont have such a setup handy.

**blackberry-deploy** is actually a frontend for a Java program "**BarDeploy.jar**". The JAR files can be found in **C:\bbndk-1.0\host\win32\x86\usr\lib**. If the tester has Java installed, you can probably rig up a simple batch file for installing the token and the binary.

A good place to start is by looking at **blockberry-deploy.bat**:

> `java -Xmx512M -jar "%~dp0\..\lib\BarDeploy.jar" %*`

Where **%*** is where the command line arguments go, and **%~dp0** is [the currently executing batch file's directory](http://stackoverflow.com/questions/5034076/what-does-dp0-mean-and-how-does-it-work). Tweak accordingly.

You are going to need a few files from **C:\bbndk-1.0\host\win32\x86\usr\lib**. BarDeploy.jar is not standalone. As of the time of this writing, I have not had the chance to go through and determine the specific dependencies. You could just cheat, and copy them all (it's only 2 MB).

The tester will need to enable Developer Mode on their device, and set a password. This password is needed when sending to the device. 

If you don't like passwords, you can disable the password once you are done, but you'll have to re-set it every time you want to send a build (in other words, developers, get used to it).

### Step 14. Submission

<font color="#ff00ff">*UNFINISHED*</font>

Again, I used [this](http://www.drmop.com/index.php/2011/08/30/marmalade-sdk-and-blackberry-playbook-from-setup-and-deployment-to-app-world-submission/) as reference.

**TODO:** Submit Smiles HD, and finish this section.

### Appendix A: Setting up new computers

You should [read this](https://bdsc.webapps.blackberry.com/native/documentation/com.qnx.doc.native_sdk.devguide/com.qnx.doc.native_sdk.devguide/topic/backup_restore_signing_keys.html). We're basically doing that.

  1. Do Step 3 (Install SDK)
  2. On original PC, browse to **C:\Users\MY\_USER\_NAME\AppData\Local\Research In Motion\**
  3. Make a copy of **author.p12**, **barsigner.csk**, and **barsigner.db**
  4. Place them in the equivalent location on the new PC (**C:\Users\MY\_USER\_NAME\AppData\Local\Research In Motion\**)

That's it.

**TODO**: See if I can use the same SSH keys across multiple computers.

### Appendix B: Setting up new devices

<font color="#ff00ff">*UNFINISHED*</font>

**TODO:** Install Smiles on Mom & Dads Xmas gift, and take note of anything.

### Appendix C: Getting AuthorId

Here's a shell script that extracts the AuthorId from a manifest file stored inside a BAR file.

> <pre>#!/bin/sh

if [ ! -n "$1" ]; then
	echo "Usage: $0 TOKEN_FILE_NAME.bar"
	exit 1
elif [ ! -e "$1" ]; then
	echo "Error! $1 doesn't exist!"
	exit 1
fi

echo "`unzip -p $1 META-INF/MANIFEST.MF | grep "Package-Author-Id:" | sed s/"Package-Author-Id: "//`"

exit 0</pre>

Use this program on your Provisioning (Debug) Token BAR file.

Alternatively, you can make a copy of the Provisioning (Debug) Token BAR file, with a ".zip" extension on the end. Then simply open it as a ZIP file, browse to **META-INF** and take a look inside **MANIFEST.MF** for the **Package-Author-Id**.

### Appendix D: GetLog.sh - A shell script for viewing the log (STDOUT)

This script retrieves the log (standard output capture) of a BAR file that was recently run on a remote device. It connects via SSH, views the file, then closes the connection.

Regrettably, opening an SSH connection to a PlayBook isn't very fast, but once connected it's speedy.

> <pre>#!/bin/sh

usage () {
	echo "Usage: $0 AppName.bar {IP_ADDRESS} {SSH_KEY}"
}

if [ ! -n "$1" ]; then
	usage
	exit 1
elif [ ! -n "$2" ]; then
	usage
	exit 1
elif [ ! -n "$3" ]; then
	usage
	exit 1
elif [ ! -e "$1" ]; then
	echo "Error! $1 doesn't exist!"
	exit 1
fi

PACKAGE_NAME=`unzip -p $1 META-INF/MANIFEST.MF | grep "Package-Name:" | sed s/"Package-Name: "//`
PACKAGE_ID=`unzip -p $1 META-INF/MANIFEST.MF | grep "Package-Id:" | sed s/"Package-Id: "//`

ACTION="cat /accounts/1000/appdata/$PACKAGE_NAME.$PACKAGE_ID/logs/log"

echo "Connecting to $2 (this can take a while)..."

ssh devuser@$2 -i $3 "$ACTION"

exit 0</pre>

Open a connection in a separate shell like you do in Step 12, then invoke this shell script.

The script extracts the Package Name and Id from the local copy of the BAR file, and uses that to build the path.

### Appendix E: Misc

Just some misc notes.

  * GDB is **ntoarm-gdb**. Start it.
  * Open a connection by doing "**target qnx IP_ADDRESS:8000**" (this is normally "target remote IP:PORT", but the protocol is a little different on QNX).
  * [Some details](https://bdsc.webapps.blackberry.com/native/documentation/com.qnx.doc.neutrino.prog/topic/using_gdb_startingprogram.html).
  * blackberry-deploy -debugNative -launchApp -device {IP_ADDRESS} -password {PASSWORD} MyApp.bar
  * The above launches the app in debugNative mode. It returns the PID (result::SOME_NUMBER).
  * From GDB do "**attach PID**", where the PID is the number returned above.

Regrettably, the above isn't very useful, as none of the debug logging is sent your way (nor does the program know anything about its symbols). Still, I've noted the details for later once I do figure this out.