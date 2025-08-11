<img width="1228" height="724" alt="Screenshot from 2025-07-25 15-03-06" src="https://github.com/user-attachments/assets/51773cbf-1832-4c00-a5fb-88607753fc29" />

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
chmod +x ursim-intsall-22.04.sh
./ursim-intsall-22.04.sh
```

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
cd /ursim-5.22.2.1214876/
./install.sh
```

Copy the URSim binaries to `/usr/bin`:

```bash
sudo cp -rv /home/$USER/ursim-5.22.2.1214876/usr/bin/* /usr/bin/
```

**URSIM installation completed**

To launch URSim:

```bash
./start-ursim.sh
```

Or click on the desktop icon.

<img width="1894" height="1079" alt="Screenshot from 2025-07-25 14-31-53" src="https://github.com/user-attachments/assets/ab892210-9b40-4c99-b62d-594c92b04789" />

You can configure the Network Settings if you need to.

<img width="1323" height="870" alt="Screenshot from 2025-07-25 12-53-14" src="https://github.com/user-attachments/assets/54fc625a-bac3-404c-8050-f03ada2b4d5b" />
<img width="1344" height="884" alt="Screenshot from 2025-07-25 12-49-03" src="https://github.com/user-attachments/assets/9c870990-2955-4f58-b650-fab7ee75cda3" />



## Troubleshooting

1. Once the installation is complete, if the desktop application icons are not launchable, right-click on the app icon and select `Allow Launching` to enable them.
<img width="2000" height="699" alt="Untitled design (1)" src="https://github.com/user-attachments/assets/165f4be1-3121-4dfa-a653-8fb34932da6e" />



## Contribute

Found a bug or something not working as expected?
Please let us know by opening a new issue in the Issues section on GitHub. We're here to help!

Have a solution or improvement?
Feel free to contribute by opening a Pull Request with your fix or enhancement. Your contributions are always welcome and appreciated!
