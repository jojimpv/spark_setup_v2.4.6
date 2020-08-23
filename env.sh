export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_OPTIONAL_TOOLS=hadoop-aws
export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export SPARK_HOME=/usr/local/spark
export PATH=${SPARK_HOME}/bin:${HADOOP_HOME}/bin:$PATH

cat <<EOF

# Added for Spark setup
export JAVA_HOME=${JAVA_HOME}
export HADOOP_HOME=${HADOOP_HOME}
export HADOOP_OPTIONAL_TOOLS=${HADOOP_OPTIONAL_TOOLS}
export HADOOP_CONF_DIR=${HADOOP_CONF_DIR}
export SPARK_HOME=${SPARK_HOME}
export SPARK_DIST_CLASSPATH=$(hadoop classpath):~/hadoop/share/hadoop/tools/lib/*
export PYSPARK_PYTHON=$(which python)

EOF
echo 'export PATH=${HADOOP_HOME}/bin:${SPARK_HOME}/bin:${PATH}'