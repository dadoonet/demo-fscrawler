source .env

FSCRAWLER_DIR=fscrawler-$FSCRAWLER_VERSION

echo Installation script for FSCrawler Search demo with Elastic Workplace Search $ELASTIC_VERSION

check_service () {
	echo -ne '\n'
	echo $1 must be available on $2
	echo "If not running, run:"
	echo $4
	echo -ne "Waiting for $1"

	until curl -u $ELASTIC_USERNAME:$ELASTIC_PASSWORD -s "$2" | grep "$3" > /dev/null ; do
			curl -u $ELASTIC_USERNAME:$ELASTIC_PASSWORD -s "$2"
		  sleep 1
			echo -ne '.'
	done

	echo -ne '\n'
	echo $1 is now up.
}

echo "##################"
echo "### Pre-checks ###"
echo "##################"

check_service "Elasticsearch $ELASTIC_VERSION" "$ELASTICSEARCH_URL" "\"number\" : \"$ELASTIC_VERSION\"" "open https://cloud.elastic.co"
check_service "Kibana $ELASTIC_VERSION" "$KIBANA_URL/app/home#/" "<title>Elastic</title>" "open https://cloud.elastic.co"
check_service "Enterprise Search $ELASTIC_VERSION" "$WORKPLACE_URL/ws/search" "$ELASTIC_VERSION" "open https://cloud.elastic.co"
check_service "Local Web server running from docs/full." "http://127.0.0.1" "test-ocr.pdf" "cd docs/full; python3 -m http.server --cgi 80"

echo -ne '\n'
echo "###########################################"
echo "### Install FSCrawler from latest build ###"
echo "###########################################"
echo -ne '\n'

rm -r $FSCRAWLER_DIR
unzip -q $FSCRAWLER_DISTRIBUTION/$FSCRAWLER_VERSION/fscrawler-distribution-$FSCRAWLER_VERSION.zip
mv fscrawler-distribution-$FSCRAWLER_VERSION $FSCRAWLER_DIR 

