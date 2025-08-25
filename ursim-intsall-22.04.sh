#!/bin/bash
set -e

INSTALL_DIR=$(pwd)

# Step 1: Install software
sudo apt-get update -y
sudo apt-get install -y openjdk-8-jdk
sudo apt-get install -y maven
sudo apt-get install -y runit
sudo apt-get update -y
sudo apt-get install -y libcurl4

wget https://s3-eu-west-1.amazonaws.com/ur-support-site/URSim_Linux-5.22.2.1214876.tar.gz
tar xvzf URSim_Linux-5.22.2.1214876.tar.gz
rm URSim_Linux-5.22.2.1214876.tar.gz
cd ursim-5.22.2.1214876/

# Step 2: Modifying install.sh
sed -i "s/commonDependencies='libcurl3/commonDependencies='libcurl4/" install.sh
sed -i 's|apt-get -y install lib32gcc1|apt-get -y install lib32gcc-s1-amd64-cross|' install.sh

# Step 4: Fixing dependencies
cd ursim-dependencies
ar x libxmlrpc-c-ur_1.33.14_amd64.deb

# Step 5: Fixing control
mkdir extras-control
tar -C extras-control -zxf control.tar.gz

# Step 6: Modify control file
cd extras-control/
sed -i 's/Depends: lib32gcc1.*/Depends: lib32gcc-s1-amd64-cross, lib32stdc++6 (>= 4.1.1), libc6-i386 (>= 2.3.4)/' control

# Step 7: Repack control.tar.gz
tar cfz control.tar.gz *
mv control.tar.gz ..
cd ..

# Step 8: Rebuild deb package
ar r new_urtool3_amd64.deb debian-binary control.tar.gz data.tar.gz
rm libxmlrpc-c-ur_1.33.14_amd64.deb
cd ..

# Step 9: Set Java environment
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Set Java/Javac in .bashrc
echo '#Java 8 for URSim' >> ~/.bashrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc

java -version

# Step 10: Run install
(cd "$INSTALL_DIR/ursim-5.22.2.1214876" && ./install.sh || true)

# Copy URSim binaries to /usr/bin
sudo cp -rv "$INSTALL_DIR/ursim-5.22.2.1214876/usr/bin/"* /usr/bin/

echo "URSIM installation completed. To run the software, use: ./start-ursim.sh or click on the desktop icon."