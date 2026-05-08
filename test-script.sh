ok=0
fail=0

cleanup() {
  total=$((ok+fail))
  echo ""
  echo "===== SUMMARY ====="
  echo "OK: $ok"
  echo "TIMEOUT/ERROR: $fail"
  if [ $total -gt 0 ]; then
    rate=$(awk "BEGIN {printf \"%.2f\", ($ok/$total)*100}")
    echo "SUCCESS RATE: ${rate}%"
  else
    echo "SUCCESS RATE: N/A"
  fi
  exit 0
}

trap cleanup INT

while true; do
  status=$(curl -k -s -o /dev/null -w "%{http_code}" https://odoo.example.local --max-time 2)

  if [ "$status" = "200" ]; then
    echo "$(date +%H:%M:%S) OK"
    ((ok++))
  else
    echo "$(date +%H:%M:%S) TIMEOUT / ERROR"
    ((fail++))
  fi

  sleep 1
done
