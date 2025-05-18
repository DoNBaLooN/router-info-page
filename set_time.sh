#!/bin/sh
echo "Content-type: text/plain"
echo ""

QUERY_STRING="${QUERY_STRING#time=}"
DECODED_TIME=$(printf '%b' "${QUERY_STRING//%/\\x}")
date -s "$DECODED_TIME" >/dev/null 2>&1 && echo "OK" || echo "FAIL"

