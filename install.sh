sudo echo "Installation started"

# install python 3.7
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.7

# install java 8
sudo apt-get install openjdk-8-jdk
sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java


# setup hadoop and spark binaries
wget https://archive.apache.org/dist/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz
wget https://downloads.apache.org/spark/spark-2.4.6/spark-2.4.6-bin-without-hadoop.tgz

sudo mkdir -p /usr/local/hadoop /usr/local/spark
sudo tar -xzvf hadoop-3.2.1.tar.gz --strip 1 --directory /usr/local/hadoop
sudo tar -xzvf spark-2.4.6-bin-without-hadoop.tgz --strip 1 --directory /usr/local/spark
sudo chmod -R 777 /usr/local/hadoop
sudo chmod -R 777 /usr/local/spark

# setup Hadoop conf file and env.sh
sudo echo '<configuration><property><name>fs.defaultFS</name><value>hdfs://localhost:9000</value></property></configuration>' > /usr/local/hadoop/etc/hadoop/core-site.xml
sudo echo '<configuration><property><name>dfs.replication</name><value>1</value></property></configuration>' > /usr/local/hadoop/etc/hadoop/hdfs-site.xml
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
sudo echo export JAVA_HOME=${JAVA_HOME} >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh
sudo echo 'export SPARK_DIST_CLASSPATH=$(/usr/local/hadoop/bin/hadoop classpath):~/hadoop/share/hadoop/tools/lib/*' >> /usr/local/spark/conf/spark-env.sh



# get env variables
source bin/env.sh >> ~/.bashrc

# setup hdfs
/usr/local/hadoop/bin/hdfs namenode -format

# setup password-less login
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

# install ssh daemon and setup
sudo apt install ssh
sudo systemctl enable --now ssh
sudo systemctl status ssh


# start hadoop and spark standalone cluster
bash /usr/local/hadoop/sbin/start-all.sh
bash /usr/local/spark/sbin/start-all.sh


