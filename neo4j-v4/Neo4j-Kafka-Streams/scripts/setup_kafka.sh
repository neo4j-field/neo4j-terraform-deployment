############################################################################################
# Version: 0.0.1
# Created Date: 01/12/2021
# Author: Maruthi Prithivirajan
# Email: maruthi.prithivirajan@neo4j.com
# Description:
# Shell script to install Confluent Kafka and Neo4j Connector
# Coverage: Kafka & Neo4j Connector
# Assets:
# Kafka - http://packages.confluent.io/archive/7.0/confluent-community-7.0.0.tar.gz
# Neo4j Connector - https://github.com/neo4j-contrib/neo4j-streams/releases/download/4.1.0/neo4j-kafka-connect-neo4j-2.0.0.zip
# Neo4j Connector Repo - https://github.com/neo4j-contrib/neo4j-streams
############################################################################################
#!/bin/bash
db_home="/home/neo4j"

#Adding Neo4j user
sudo useradd -m neo4j -s /bin/bash
echo "neo4j     ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo
sudo su -l neo4j
# Installing OpenJDK 11
sudo apt-get update
sudo apt-get install default-jdk unzip -y
# Mounting storage volume for Neo4j DB datastore
# sudo lsblk # Uncomment to check available disks
sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
# sudo chown neo4j:neo4j /data
sudo mount -o discard,defaults /dev/sdb $db_home
sudo cp /etc/fstab /etc/fstab.backup
uuid=$(sudo blkid /dev/sdb | awk -F '"' '{print $2}')
sudo echo "UUID=$uuid $db_home discard,defaults,nofail 0 2" | sudo tee -a /etc/fstab
# Copy DB files from GCS to VM
sudo su -l neo4j
sudo mkdir -p $db_home/installation-staging
sudo gsutil -m cp -r gs://${bucket_name}/* $db_home/installation-staging
# sudo gsutil -m cp -r gs://terraform-neo4j-dev-02/* /home/neo4j/installation-staging
cd /home/neo4j
tar xzf /home/neo4j/installation-staging/confluent-community-7.0.0.tar
# sudo tee -a /home/neo4j/.bashrc >/dev/null <<EOT
echo " " >>/home/neo4j/.bashrc
echo "# Kafka settings" >>/home/neo4j/.bashrc
echo "CONFLUENT_HOME=/home/neo4j/confluent-7.0.0" >>/home/neo4j/.bashrc
echo "export CONFLUENT_HOME" >>/home/neo4j/.bashrc
echo "export KAFKA_HEAP_OPTS=\"-Xms1g -Xmx3g\"" >>/home/neo4j/.bashrc
echo "PATH=$PATH:$HOME/bin:$CONFLUENT_HOME/bin" >>/home/neo4j/.bashrc
echo "export PATH >>/home/neo4j/.bashrc"
# EOT
source /home/neo4j/.bashrc
cp /home/neo4j/confluent-7.0.0/etc/kafka/connect-distributed.properties /home/neo4j/confluent-7.0.0/etc/kafka/connect-distributed.properties.bak
sed -i 's/group.id=connect-cluster/group.id=neo4j-connect-cluster/' /home/neo4j/confluent-7.0.0/etc/kafka/connect-distributed.properties
sed -i 's/plugin.path=\/usr\/share\/java/plugin.path=\/usr\/share\/java,\/home\/neo4j\/plugins/' /home/neo4j/confluent-7.0.0/etc/kafka/connect-distributed.properties
mkdir /home/neo4j/confluent-data
cp /home/neo4j/confluent-7.0.0/etc/kafka/kraft/server.properties /home/neo4j/confluent-7.0.0/etc/kafka/kraft/server.properties.bak
sed -i 's/log.dirs=\/tmp\/kraft-combined-logs/log.dirs=\/home\/neo4j\/confluent-data\/kraft-combined-logs/' /home/neo4j/confluent-7.0.0/etc/kafka/kraft/server.properties
mkdir plugins
cd plugins
unzip ../installation-staging/neo4j-kafka-connect-neo4j-2.0.0.zip
sudo chown -R neo4j:neo4j /home/neo4j/*

sudo /home/neo4j/confluent-7.0.0/bin/kafka-storage format --config /home/neo4j/confluent-7.0.0/etc/kafka/kraft/server.properties --cluster-id $(/home/neo4j/confluent-7.0.0/bin/kafka-storage random-uuid) --ignore-formatted
sudo /home/neo4j/confluent-7.0.0/bin/kafka-server-start -daemon /home/neo4j/confluent-7.0.0/etc/kafka/kraft/server.properties
sudo /home/neo4j/confluent-7.0.0/bin/connect-distributed -daemon /home/neo4j/confluent-7.0.0/etc/kafka/connect-distributed.properties /home/neo4j/confluent-7.0.0/etc/kafka/connect-file-source.properties /home/neo4j/confluent-7.0.0/etc/kafka/connect-file-sink.properties
sleep 120s
sudo /home/neo4j/confluent-7.0.0/bin/kafka-topics --bootstrap-server localhost:9092 --topic neo4j-test --partitions=1 --replication-factor=1 --create

cd /home/neo4j/confluent-7.0.0/etc/kafka
cp /home/neo4j/installation-staging/*.properties .
sudo curl -X POST http://localhost:8083/connectors -H 'Content-Type:application/json' -H 'Accept:application/json' -d @sink_connector.properties
sudo curl -X POST http://localhost:8083/connectors -H 'Content-Type:application/json' -H 'Accept:application/json' -d @source_connector.properties

# Leaving these for references incase manual operations are required
# kafka-topics --bootstrap-server localhost:9092 --topic neo4j-test --delete
# curl http://localhost:8083/connectors
# curl -X DELETE http://localhost:8083/connectors/neo4j_test_sink
# curl -X DELETE http://localhost:8083/connectors/neo4j_test_source
# kafka-console-consumer --bootstrap-server localhost:9092 --topic neo4j-test --from-beginning
# kafka-console-producer --broker-list localhost:9092 --topic neo4j-test
