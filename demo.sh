source .env

FSCRAWLER_DIR=fscrawler-$FSCRAWLER_VERSION

echo "To run the Tika demo, run:"
echo "# Extracted text"
echo "cat docs/test/foo.txt | java -jar tika/tika-app-*.jar --text"
echo "# Metadata"
echo "cat docs/test/foo.txt | java -jar tika/tika-app-*.jar --metadata"
echo "# Metadata as JSON"
echo "cat docs/test/foo.txt | java -jar tika/tika-app-*.jar --json | jq"

echo ""

echo "To run the Ingest attachment demo, run:"
echo "# Convert text to BASE64"
echo "cat docs/test/foo.txt | base64"
echo "# Call the _simulate endpoint"
echo "./simulate.sh docs/test/foo.txt"

echo ""

echo "To run the FSCrawler demo, run:"
echo "cd $FSCRAWLER_DIR"
echo "bin/fscrawler --debug --config_dir jobs"

