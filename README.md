<img width="1228" height="724" alt="Screenshot from 2025-07-25 15-03-06" src="https://github.com/user-attachments/assets/262cd570-95cd-480f-b2c2-ba320d7172c1" />

# URSim 5.22.2 Install on Ubuntu 22.04

This repository provides instructions for installing URSim 5.22.2 (UR-Series & e-Series) on Ubuntu 22.04 without using Docker.
If you prefer to run URSim inside a Docker container, please refer to the official image and instructions here: [UR Sim Docker Image](https://hub.docker.com/r/universalrobots/ursim_e-series).

## Installation Methods

This repository describes two methods for installing URSim:

**1. Using an installation shell script** <br />
**2. Manual installation**

## 1. Using the Installation Shell Script

You can clone the repository, make the script executable, and run it to install URSim automatically. Use the following command:

```bash
git clone https://github.com/SAJIB3489/URSim-ubuntu-22.04.git
cd URSim-ubuntu-22.04
```

Vist [URSim 5.22.2](https://www.universal-robots.com/download/software-ur-series/simulator-linux/offline-simulator-ur-series-e-series-ur-sim-for-linux-5222/) and copy the download link and past it to []()

> [!NOTE]
> You may need to log in or create an account before accessing the download.

<img width="1796" height="856" alt="link-copy-paste" src="https://github.com/user-attachments/assets/0f8a048f-704f-4395-b830-d3e97df26944" />

```bash
git clone https://github.com/SAJIB3489/URSim-ubuntu-22.04.git
cd URSim-ubuntu-22.04
chmod +x ursim-intsall-22.04.sh
./ursim-intsall-22.04.sh
```

**Enable Modbus server in URSim**

As per default, the Modbus server is activated. In case it is not then open the file `starturcontrol.sh` which is located in the installation folder using a file editor. Open `/ursim-5.22.2.1214876/starturcontrol.sh`

Replace:

```bash
HOME=$SCRIPT_DIR $SCRIPT_DIR/URControl -m $PRODUCT_VERSION -r &>$SCRIPT_DIR/URControl.log &
```

With:

```bash
echo mypasswd | sudo -S HOME=$SCRIPT_DIR $SCRIPT_DIR/URControl -m $PRODUCT_VERSION -r &>$SCRIPT_DIR/URControl.log &
```
Here, replace **mypasswd** with your login password for Linux. 

-----------------------------------------------------------------------------------------------------------------------------

## 2. Manual Installation

### Prerequisites

Before installing URSim 5.22.2, ensure the following dependencies are installed. This will help avoid errors during the installation process on Ubuntu 22.04.

Copy and run the following command in your terminal:

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

You can download URSim **5.22.2 (Offline PolyScope simulator)** from the official Universal Robots website: [URSim 5.22.2](https://www.universal-robots.com/download/software-ur-series/simulator-linux/offline-simulator-ur-series-e-series-ur-sim-for-linux-5222/)

> [!NOTE]
> You may need to log in or create an account before accessing the download.

Alternatively, you can download the software directly using the following link:

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

**3. Modify intsall.sh**

Open `install.sh` and make the following changes:

**Change 1**

Replace:

```bash
commonDependencies='libcurl3 libjava3d-* ttf-dejavu* fonts-ipafont fonts-baekmuk fonts-nanum fonts-arphic-uming fonts-arphic-ukai'
```

With:

```bash
commonDependencies='libcurl4 libjava3d-* ttf-dejavu* fonts-ipafont fonts-baekmuk fonts-nanum fonts-arphic-uming fonts-arphic-ukai'
```

**Change 2**

Replace:

```bash
sudo bash -c "apt-get -y install lib32gcc1 lib32stdc++6 libc6-i386 $commonDependencies && (echo '$packages' | xargs dpkg -i --force-overwrite)"
```

With:

```bash
sudo bash -c "apt-get -y install lib32gcc-s1-amd64-cross lib32stdc++6 libc6-i386 $commonDependencies && (echo '$packages' | xargs dpkg -i --force-overwrite)"
```

**4. Fix Dependency Package**

You need to fix the dependency packages.

```bash
cd ursim-dependencies/
ar x libxmlrpc-c-ur_1.33.14_amd64.deb
mkdir extras-control
tar -C extras-control -zxf control.tar.gz
cd extras-control/
```

**5. Modify the `control` file**

Edit the `control` file in extras-control/ and change:

```bash
Depends: lib32gcc1 (>= 1:4.1.1), lib32stdc++6 (>= 4.1.1), libc6-i386 (>= 2.3.4)
```

To:

```bash
Depends: lib32gcc-s1-amd64-cross, lib32stdc++6 (>= 4.1.1), libc6-i386 (>= 2.3.4)
```

**6. Repack and Rebuild `.deb`**

You need to repack the control.tar.gz file and rebuild.

```bash
tar cfz control.tar.gz *
mv control.tar.gz ..
cd ..
ar r new_urtool3_amd64.deb debian-binary control.tar.gz data.tar.gz
rm libxmlrpc-c-ur_1.33.14_amd64.deb
cd ..
```

**7. Set Java Environment**

If multiple Java versions are installed, set Java 8:

```bash
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
```

To persist the environment settings, add to `~/.bashrc`:

```bash
echo '#Java 8 for URSim' >> ~/.bashrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
```

Verify:

```bash
java -version
```

**8. Run the Installer**

All set, now you can run **_install.sh_** script.

```bash
./install.sh
```

Copy the URSim binaries to `/usr/bin`:

```bash
sudo cp -rv /home/$USER/ursim-5.22.2.1214876/usr/bin/* /usr/bin/
```

**9. Enable Modbus server in URSim**

As per default, the Modbus server is activated. In case it is not then open the file `starturcontrol.sh` which is located in the installation folder using a file editor. Open `/ursim-5.22.2.1214876/starturcontrol.sh`

Replace:

```bash
HOME=$SCRIPT_DIR $SCRIPT_DIR/URControl -m $PRODUCT_VERSION -r &>$SCRIPT_DIR/URControl.log &
```

With:

```bash
echo mypasswd | sudo -S HOME=$SCRIPT_DIR $SCRIPT_DIR/URControl -m $PRODUCT_VERSION -r &>$SCRIPT_DIR/URControl.log &
```
Here, replace **mypasswd** with your login password for Linux. 

---------------------------------------------------------------------------------------------------
**🟩 URSIM installation completed.**

To launch URSim:

```bash
./start-ursim.sh
```

Or click on the desktop icon.

<img width="1894" height="1079" alt="Screenshot from 2025-07-25 14-31-53" src="https://github.com/user-attachments/assets/81677e69-513d-4b7b-83c2-627b20e8bb0a" />

You can configure the Network Settings if you need to.


<img width="1323" height="870" alt="Screenshot from 2025-07-25 12-53-14" src="https://github.com/user-attachments/assets/4a94c218-14a3-4521-aad4-dc4a448a29c8" />
<img width="1344" height="884" alt="Screenshot from 2025-07-25 12-49-03" src="https://github.com/user-attachments/assets/23d97e21-a518-4ea7-a710-aab6844e7d08" />



## Troubleshooting

1. Once the installation is complete, if the desktop application icons are not launchable, right-click on the app icon and select `Allow Launching` to enable them.

<img width="1346" height="448" alt="Screenshot from 2025-08-11 22-12-04" src="https://github.com/user-attachments/assets/842ca4c5-97eb-42f6-9757-2879928f7dc0" />


2. If the Controller is OK but you can not click on **🟢ON** button in URSim or terminal log shows **Controller monitoring timed out while waiting for real time robot data, Controller monitoring timed out too many times. Restarting connection**, then stop the urcontrol using `sudo ./stopurcontrol.sh`. After that launch the Software or *_./start-ursim.sh_*.

<img width="1205" height="461" alt="Screenshot from 2025-08-11 21-59-36" src="https://github.com/user-attachments/assets/41090336-281b-48cd-ab98-fa8646357ad0" />

----------------------------------
## Uninstall or Remove

Run the following command to fully remove URSim.

```bash
sudo rm -r URSim-ubuntu-22.04/
sudo rm -r /usr/bin/ur*
sudo rm -r /$HOME/Desktop/*
sudo rm -r /usr/local/ur*
```

## Contribute

Found a bug or something not working as expected?
Please let us know by opening a new issue in the Issues section on GitHub. We're here to help!

Have a solution or improvement?
Feel free to contribute by opening a Pull Request with your fix or enhancement. Your contributions are always welcome and appreciated!


## Acknowledgements

* [Universal Robots](https://www.universal-robots.com/download/software-ur-series/simulator-linux/offline-simulator-ur-series-e-series-ur-sim-for-linux-5222/)
