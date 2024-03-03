#!/usr/bin/env bash
# set -x

declare -i rc=0

export TERM=xterm-color

BASE_PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
BASE_LD_LIBRARY_PATH=""

declare -A jdk_distribs
jdk_distribs[8]="${HOME}/tools/jdk8u402-b06"
jdk_distribs[11]="${HOME}/tools/jdk-11.0.22+7"
jdk_distribs[17]="${HOME}/tools/jdk-17.0.10+7"
jdk_distribs[21]="${HOME}/tools/jdk-21.0.2+13"

declare -A py_distribs
py_distribs[2]="${HOME}/tools/miniconda2"
py_distribs[3]="${HOME}/tools/miniconda3"

declare -A spark_distribs
spark_distribs[1.3.1]="${HOME}/tools/spark-1.3.1-bin-hadoop2.6"
spark_distribs[1.4.1]="${HOME}/tools/spark-1.4.1-bin-hadoop2.6"
spark_distribs[1.5.2]="${HOME}/tools/spark-1.5.2-bin-hadoop2.6"
spark_distribs[1.6.3]="${HOME}/tools/spark-1.6.3-bin-hadoop2.6"
spark_distribs[2.0.2]="${HOME}/tools/spark-2.0.2-bin-hadoop2.7"
spark_distribs[2.1.3]="${HOME}/tools/spark-2.1.3-bin-hadoop2.7"
spark_distribs[2.2.3]="${HOME}/tools/spark-2.2.3-bin-hadoop2.7"
spark_distribs[2.3.4]="${HOME}/tools/spark-2.3.4-bin-hadoop2.7"
spark_distribs[2.4.4]="${HOME}/tools/spark-2.4.4-bin-hadoop2.7"
spark_distribs[2.4.8]="${HOME}/tools/spark-2.4.8-bin-hadoop2.7"
spark_distribs[3.0.3]="${HOME}/tools/spark-3.0.3-bin-hadoop3.2"
spark_distribs[3.1.3]="${HOME}/tools/spark-3.1.3-bin-hadoop3.2"
spark_distribs[3.2.4]="${HOME}/tools/spark-3.2.4-bin-hadoop3.2"
spark_distribs[3.3.1]="${HOME}/tools/spark-3.3.1-bin-hadoop3"
spark_distribs[3.3.4]="${HOME}/tools/spark-3.3.4-bin-hadoop3"
spark_distribs[3.4.2]="${HOME}/tools/spark-3.4.2-bin-hadoop3"
spark_distribs[3.5.0]="${HOME}/tools/spark-3.5.0-bin-hadoop3"

declare -A hadoop_distribs
hadoop_distribs[2.4.1]="${HOME}/tools/hadoop-2.4.1"
hadoop_distribs[2.5.2]="${HOME}/tools/hadoop-2.5.2"
hadoop_distribs[2.6.5]="${HOME}/tools/hadoop-2.6.5"
hadoop_distribs[2.7.7]="${HOME}/tools/hadoop-2.7.7"
hadoop_distribs[2.8.5]="${HOME}/tools/hadoop-2.8.5"
hadoop_distribs[2.9.2]="${HOME}/tools/hadoop-2.9.2"
hadoop_distribs[2.10.1]="${HOME}/tools/hadoop-2.10.1"
hadoop_distribs[3.1.1]="${HOME}/tools/hadoop-3.1.1"
hadoop_distribs[3.1.4]="${HOME}/tools/hadoop-3.1.4"
hadoop_distribs[3.2.4]="${HOME}/tools/hadoop-3.2.4"
hadoop_distribs[3.3.6]="${HOME}/tools/hadoop-3.3.6"

declare -a test_matrix=(
    "1.3.1|2.6.5|8|3|1.6.0rc3|2.2.0rc1|0.7.0|||"
    "1.4.1|2.6.5|8|3|1.6.0rc3|2.2.0rc1|0.7.0|||"
    "1.5.2|2.6.5|8|3|1.6.0|2.2.0rc1|0.7.0|1.7.0|2.3.0-incubating|0.7.0"
    "1.6.3|2.6.5|8|3|1.6.0|2.2.0rc1|0.7.0|1.7.0|2.3.0-incubating|0.7.0"
    "2.0.2|2.7.7|8|3|1.6.0|2.2.0rc1|0.7.0|1.7.0|2.3.0-incubating|0.7.0"
    "2.1.3|2.7.7|8|3|1.6.0|2.2.0rc1|0.7.0|1.8.1|2.3.0-incubating|0.7.0"
    "2.2.3|2.7.7|8|3|1.6.0|2.2.0rc1|0.7.0|1.8.2|2.3.1|0.7.0"
    "2.3.4|2.7.7|8|3|1.6.0|2.2.0rc1|0.7.0|1.8.3|2.3.1|0.7.0"
    "2.4.4|2.7.7|8|3|1.6.0|2.2.0rc1|0.7.0|1.10.1|2.4.0|0.9.3"
    "2.4.5|2.7.7|8|3|1.6.0|2.2.0rc1|0.7.0|1.10.1|2.4.0|0.9.3"
    "2.4.6|2.7.7|8|3|1.6.0|2.2.0rc1|0.7.0|1.10.1|2.4.0|0.9.3"
    "2.4.7|2.7.7|8|3|1.6.0|2.2.0rc1|0.7.0|1.10.1|2.4.0|0.9.3"
    "2.4.8|2.7.7|8|3|1.6.0|2.2.0rc1|0.7.0|1.10.1|2.4.0|0.9.3"
    "3.0.3|3.2.4|8|3||||1.10.1|2.4.0|0.9.3"
    "3.1.3|3.2.4|8|3||||1.10.1|2.4.0|0.9.3"
    "3.2.4|3.2.4|8|3||||1.12.2|2.8.0|0.13.0"
    "3.3.1|3.3.6|8|3||||1.12.2|2.8.0|0.13.0"
    "3.3.4|3.3.6|8|3||||1.12.2|2.8.0|0.13.0"
    "3.4.2|3.3.6|11|3||||1.12.3|2.9.0|0.16.0"
    "3.5.0|3.3.6|17|3||||1.13.1|2.9.0|0.16.0"
)

for test in "${test_matrix[@]}"
do
    IFS="|" read -r sparkVersion hadoopVersion jdkDist pyDist \
        twitterParquetCommonVersion twitterParquetFormatVersion twitterParquetThriftVersion \
        apacheParquetCommonVersion apacheParquetFormatVersion apacheParquetThriftVersion \
        _ <<< "${test}"

    testId="read__${sparkVersion}__${hadoopVersion}__${jdkDist}__${pyDist}"

    echo "${testId}..."

    export PATH="${BASE_PATH}"
    export LD_LIBRARY_PATH="${BASE_LD_LIBRARY_PATH}"

    export JAVA_HOME="${jdk_distribs["${jdkDist}"]}"
    export JDK_HOME="${JAVA_HOME}"
    export PATH="${JAVA_HOME}/bin:${PATH}"

    export PYTHON_HOME="${py_distribs["${pyDist}"]}"
    export PATH="${PYTHON_HOME}/bin:${PATH}"

    export SPARK_HOME="${spark_distribs["${sparkVersion}"]}"
    export PATH="${SPARK_HOME}/bin:${PATH}"

    export HADOOP_HOME="${hadoop_distribs["${hadoopVersion}"]}"
    export LD_LIBRARY_PATH="${HADOOP_HOME}/lib/native"
    export PATH="${HADOOP_HOME}/bin:${PATH}"

    spark-shell \
        -deprecation \
        --conf spark.args.testId="${testId}" \
        --conf spark.args.sparkVersion="${sparkVersion}" \
        --conf spark.args.hadoopVersion="${hadoopVersion}" \
    < "${HOME}/tests/read-${sparkVersion}-sql.scala" \
    2>&1 \
    | tee "${HOME}/logs/${testId}.log"
done
