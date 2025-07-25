## URSim 5.22 Install on Ubuntu 22.04

### Prerequisites:

The prerequisites to install URSim 5.22, the user must install the following software. It will ensure that the SRSim will install on Ubuntu 22.04 without any errors.

Copy the following command:

```bash
sudo apt-get update -y
sudo apt-get install -y openjdk-8-jdk
sudo apt-get install -y maven
sudo apt-get install -y runit
sudo apt-get update -y
sudo apt-get install -y libcurl4
```

### Install the URSim

**1. Download the software**

You can download Offline Simulator [URSim 5.22.2](https://www.universal-robots.com/download/software-ur-series/simulator-linux/offline-simulator-ur-series-e-series-ur-sim-for-linux-5222/) from the universal-robots website and follow the process. You probably need to login first to download the software.

You can also download the software using the following link:

```bash
cd ~
wget https://s3-eu-west-1.amazonaws.com/ur-support-site/252750/URSim_Linux-5.22.2.1214876.tar.gz
```

**2. Extract the software**

You need to extract the software.

```bash
tar xvzf URSim_Linux-5.22.2.1214876.tar.gz
rm URSim_Linux-5.22.2.1214876.tar.gz
cd ursim-5.22.2.1214876/
```

**3. Modifying intsall.sh**

You need to modify the **_install.sh_** file.

Look for this line:

```bash
commonDependencies='libcurl3 libjava3d-* ttf-dejavu* fonts-ipafont fonts-baekmuk fonts-nanum fonts-arphic-uming fonts-arphic-ukai'
```

Replace with:

```bash
commonDependencies='libcurl4 libjava3d-* ttf-dejavu* fonts-ipafont fonts-baekmuk fonts-nanum fonts-arphic-uming fonts-arphic-ukai'
```

Then look for another line:

```bash
sudo bash -c "apt-get -y install lib32gcc1 lib32stdc++6 libc6-i386 $commonDependencies && (echo '$packages' | xargs dpkg -i --force-overwrite)"
```

Replace with:

```bash
sudo bash -c "apt-get -y install lib32gcc-s1-amd64-cross lib32stdc++6 libc6-i386 $commonDependencies && (echo '$packages' | xargs dpkg -i --force-overwrite)"
```

**4. Fixing dependencies**

You need to fix the dependencies.

```bash
cd ursim-dependencies/
ar x libxmlrpc-c-ur_1.33.14_amd64.deb
mkdir extras-control
tar -C extras-control -zxf control.tar.gz
cd extras-control/
```

**5. Modify control file**

You need to modify the **_control_** file in extras-control/ directory. Open the _control_ file and

Look for this line:

```bash
Depends: lib32gcc1 (>= 1:4.1.1), lib32stdc++6 (>= 4.1.1), libc6-i386 (>= 2.3.4)
```

Replace with:

```bash
Depends: lib32gcc-s1-amd64-cross, lib32stdc++6 (>= 4.1.1), libc6-i386 (>= 2.3.4)
```

**6. Repack control.tar.gz and rebuild the deb package**

You need to repack the control.tar.gz file and rebuild.

```bash
tar cfz control.tar.gz \*
mv control.tar.gz ..
cd ..
ar r new_urtool3_amd64.deb debian-binary control.tar.gz data.tar.gz
rm libxmlrpc-c-ur_1.33.14_amd64.deb
cd ..
```

**7. Set Java environment**

If you have multiple Java versions on your PC, you can set the Java environment.

```bash
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
```

You can also add them to your .bashrc file. So, for the new session, you don't need to set the environment manually.

```bash
echo '#Java 8 for URSim' >> ~/.bashrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
```

You can verify your Java version.

```bash
java -version
```

**8. Run install**

All set, now you can run **_install.sh_** script.

```bash
cd /ursim-5.22.2.1214876/
./install.sh
```

Copy URSim binaries to /usr/bin

```bash
sudo cp -rv /home/$USER/ursim-5.22.2.1214876/usr/bin/* /usr/bin/
```

**URSIM installation completed. To run the software, use: ./start-ursim.sh or click on the desktop icon.**

<img width="1894" height="1079" alt="Screenshot from 2025-07-25 14-31-53" src="https://github.com/user-attachments/assets/ab892210-9b40-4c99-b62d-594c92b04789" />

You can configure the Network Settings if you need to.
<img width="1323" height="870" alt="Screenshot from 2025-07-25 12-53-14" src="https://github.com/user-attachments/assets/54fc625a-bac3-404c-8050-f03ada2b4d5b" />
<img width="1344" height="884" alt="Screenshot from 2025-07-25 12-49-03" src="https://github.com/user-attachments/assets/9c870990-2955-4f58-b650-fab7ee75cda3" />

## Contribute

Found a bug or something not working as expected?
Please let us know by opening a new issue in the Issues section on GitHub. We're here to help!

Have a solution or improvement?
Feel free to contribute by opening a Pull Request with your fix or enhancement. Your contributions are always welcome and appreciated!
