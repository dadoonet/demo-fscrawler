source .env

FSCRAWLER_DIR=fscrawler-$FSCRAWLER_VERSION

echo "Sending $1 to /_ingest/pipeline/attachment/_simulate"

BASE64=`cat $1 | base64`
echo "{ \"docs\": [ { \"_source\": { \"data\": \"$BASE64\"}}]}" > /tmp/demo-fscrawler.json

echo "### REQUEST ###"
cat /tmp/demo-fscrawler.json | jq

echo ""
echo "### RESPONSE ###"
curl -XPOST -s -u $ELASTIC_USERNAME:$ELASTIC_PASSWORD "$ELASTICSEARCH_URL/_ingest/pipeline/attachment/_simulate" -H 'Content-Type: application/json' --data-binary "@/tmp/demo-fscrawler.json" | jq
