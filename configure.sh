source .env

#FSCRAWLER_CONFIG_DIR=~/.fscrawler
FSCRAWLER_DIR=fscrawler-$FSCRAWLER_VERSION
FSCRAWLER_CONFIG_DIR=$FSCRAWLER_DIR/jobs

DOCUMENTS=/Users/dpilato/Documents/Elasticsearch/Talks/workplace-search-fscrawler/docs

echo Installing FSCrawler configuration files in $FSCRAWLER_CONFIG_DIR

generate_fscrawler_wp_config () {
	mkdir $FSCRAWLER_CONFIG_DIR/$1

	cat <<EOF > $FSCRAWLER_CONFIG_DIR/$1/_settings.yaml
---
name: "$1"
fs:
  url: "$DOCUMENTS/$2"
  lang_detect: true
elasticsearch:
  username: "$ELASTIC_USERNAME"
  password: "$3"
  nodes:
  - cloud_id: "$CLOUD_ID"
workplace_search:
  server: "$WORKPLACE_URL"
EOF
}

generate_fscrawler_config () {
  mkdir $FSCRAWLER_CONFIG_DIR/$1

  cat <<EOF > $FSCRAWLER_CONFIG_DIR/$1/_settings.yaml
---
name: "$1"
fs:
  url: "$DOCUMENTS/$2"
  lang_detect: true
elasticsearch:
  username: "$ELASTIC_USERNAME"
  password: "$3"
  nodes:
  - cloud_id: "$CLOUD_ID"
EOF
}

echo -ne '\n'
echo "#####################################################"
echo "### Remove attachment pipeline from Elasticsearch ###"
echo "#####################################################"
echo -ne '\n'

curl -XDELETE "$ELASTICSEARCH_URL/_ingest/pipeline/attachment" -u $ELASTIC_USERNAME:$ELASTIC_PASSWORD ; echo

echo -ne '\n'
echo "##############################################"
echo "### Remove demo indices from Elasticsearch ###"
echo "##############################################"
echo -ne '\n'

curl -XDELETE "$ELASTICSEARCH_URL/demo-few-docs" -u $ELASTIC_USERNAME:$ELASTIC_PASSWORD ; echo
curl -XDELETE "$ELASTICSEARCH_URL/demo-few-docs_folder" -u $ELASTIC_USERNAME:$ELASTIC_PASSWORD ; echo
curl -XDELETE "$ELASTICSEARCH_URL/demo-all-docs" -u $ELASTIC_USERNAME:$ELASTIC_PASSWORD ; echo
curl -XDELETE "$ELASTICSEARCH_URL/demo-all-docs_folder" -u $ELASTIC_USERNAME:$ELASTIC_PASSWORD ; echo
curl -XDELETE "$ELASTICSEARCH_URL/demo-wp-all-docs" -u $ELASTIC_USERNAME:$ELASTIC_PASSWORD ; echo
curl -XDELETE "$ELASTICSEARCH_URL/demo-wp-all-docs_folder" -u $ELASTIC_USERNAME:$ELASTIC_PASSWORD ; echo

echo -ne '\n'
echo "########################################"
echo "### Generate FSCrawler configuration ###"
echo "########################################"
echo -ne '\n'

rm -r $FSCRAWLER_CONFIG_DIR
mkdir $FSCRAWLER_CONFIG_DIR

generate_fscrawler_config demo-few-docs test $ELASTIC_PASSWORD
generate_fscrawler_config demo-all-docs full $ELASTIC_PASSWORD
generate_fscrawler_wp_config demo-wp-all-docs full $ELASTIC_PASSWORD 

echo -ne '\n'
echo "#####################"
echo "### Demo is ready ###"
echo "#####################"
echo -ne '\n'

echo "Open Elastic Dev Console and paste the following script"
echo "open $KIBANA_URL/app/dev_tools"
cat console.txt

echo "Open Wokplace Search and remove the Custom source named Local files for demo-wp-all-docs"
echo "open $KIBANA_URL/app/enterprise_search/workplace_search/sources"

echo "To run the demo, run:"
echo "cd $FSCRAWLER_DIR"

echo "bin/fscrawler --debug --config_dir jobs"

