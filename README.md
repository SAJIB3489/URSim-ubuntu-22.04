## URSim 5.22 Install on Ubuntu 22.04

### Prerequisites:

The prerequisities to install URSim 5.22, the user must install the following software. It will ensure that the SRSim will install on Ubuntu 22.04 without any error.

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

You need to modify the **_intsall.sh_** file.

Look for this line:

```bash
commonDependencies='libcurl3 libjava3d-* ttf-dejavu* fonts-ipafont fonts-baekmuk fonts-nanum fonts-arphic-uming fonts-arphic-ukai'
```

Replace with:

```bash
commonDependencies='libcurl4 libjava3d-* ttf-dejavu* fonts-ipafont fonts-baekmuk fonts-nanum fonts-arphic-uming fonts-arphic-ukai'
```

# Step 4: Fixing dependencies

cd ursim-dependencies
ar x libxmlrpc-c-ur_1.33.14_amd64.deb

# Step 5: Fixing control

mkdir extras-control
tar -C extras-control -zxf control.tar.gz

# Step 6: Modify control file

cd extras-control/
sed -i 's/Depends: lib32gcc1.\*/Depends: lib32gcc-s1-amd64-cross, lib32stdc++6 (>= 4.1.1), libc6-i386 (>= 2.3.4)/' control

# Step 7: Repack control.tar.gz

tar cfz control.tar.gz \*
mv control.tar.gz ..
cd ..

# Step 8: Rebuild deb package

ar r new_urtool3_amd64.deb debian-binary control.tar.gz data.tar.gz
rm libxmlrpc-c-ur_1.33.14_amd64.deb
cd ..

# Step 9: Set Java environment

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Automatically set Java/Javac

echo '#Java 8 for URSim' >> ~/.bashrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc

java -version

# Step 10: Run install

(cd "$INSTALL_DIR/ursim-5.22.2.1214876" && ./install.sh || true)

# Copy URSim binaries to /usr/bin

sudo cp -rv "$INSTALL_DIR/ursim-5.22.2.1214876/usr/bin/"\* /usr/bin/
