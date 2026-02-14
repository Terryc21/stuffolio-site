#!/bin/bash
# IndexNow URL Submission Script for stuffolio.app
# Notifies search engines when content is added or updated
#
# Usage:
#   ./scripts/indexnow.sh                    # Submit all pages
#   ./scripts/indexnow.sh features.html      # Submit specific page
#   ./scripts/indexnow.sh page1.html page2.html  # Submit multiple pages
#
# Setup:
#   export INDEXNOW_KEY="your-key-here"
#   Or add to ~/.zshrc or ~/.bashrc

set -e

HOST="stuffolio.app"
BASE_URL="https://stuffolio.app"

# Check for API key
if [ -z "$INDEXNOW_KEY" ]; then
    echo "Error: INDEXNOW_KEY environment variable not set"
    echo "Run: export INDEXNOW_KEY=\"your-key-here\""
    exit 1
fi

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Build URL list
if [ $# -eq 0 ]; then
    # No arguments - submit all HTML pages
    echo "Submitting all pages to IndexNow..."

    URLS=$(cd "$PROJECT_ROOT" && find . -name "*.html" -not -path "./node_modules/*" | \
        sed 's|^\./||' | \
        sed "s|^|\"$BASE_URL/|" | \
        sed 's|$|"|' | \
        tr '\n' ',' | \
        sed 's/,$//')

    # Add root URL
    URLS="\"$BASE_URL/\",$URLS"
else
    # Specific pages provided
    echo "Submitting specified pages to IndexNow..."

    URLS=""
    for page in "$@"; do
        # Handle both "page.html" and full URLs
        if [[ "$page" == http* ]]; then
            URLS="$URLS\"$page\","
        else
            URLS="$URLS\"$BASE_URL/$page\","
        fi
    done
    URLS="${URLS%,}"  # Remove trailing comma
fi

# Build JSON payload
JSON_PAYLOAD=$(cat <<EOF
{
    "host": "$HOST",
    "key": "$INDEXNOW_KEY",
    "keyLocation": "$BASE_URL/$INDEXNOW_KEY.txt",
    "urlList": [$URLS]
}
EOF
)

# Submit to IndexNow
echo "Sending to IndexNow API..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "https://api.indexnow.org/indexnow" \
    -H "Content-Type: application/json" \
    -d "$JSON_PAYLOAD")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

case $HTTP_CODE in
    200)
        echo "✓ Success: URLs submitted and accepted"
        ;;
    202)
        echo "✓ Accepted: URLs queued for processing"
        ;;
    400)
        echo "✗ Error 400: Bad request - check URL format"
        echo "$BODY"
        exit 1
        ;;
    403)
        echo "✗ Error 403: Key not valid for this host"
        exit 1
        ;;
    422)
        echo "✗ Error 422: Invalid URLs in request"
        echo "$BODY"
        exit 1
        ;;
    429)
        echo "✗ Error 429: Too many requests - try again later"
        exit 1
        ;;
    *)
        echo "✗ Unexpected response: HTTP $HTTP_CODE"
        echo "$BODY"
        exit 1
        ;;
esac

echo "Done!"
