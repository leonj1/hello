# SMOKETEST.md

# Smoke Tests

This document contains smoke tests for the static HTML project deployed via [my-deployer](https://github.com/leonj1/my-deployer) to AWS (S3 + CloudFront + Route53).

## Base URL

```
BASE_URL=https://hello.joseserver.com
```

---

## Endpoint Test Cases

- GET / -> 200
- GET /index.html -> 200
- GET /chat.html -> 200
- GET /favicon.ico -> 200
- GET /nonexistent-page.html -> 404

---

## Curl Verification Commands

### Check main page is reachable

```bash
curl -o /dev/null -s -w "%{http_code}" "$BASE_URL/" | grep -q "200" && echo "PASS: / returned 200" || echo "FAIL: / did not return 200"
```

### Check index.html is served correctly

```bash
curl -o /dev/null -s -w "%{http_code}" "$BASE_URL/index.html" | grep -q "200" && echo "PASS: /index.html returned 200" || echo "FAIL: /index.html did not return 200"
```

### Check chat interface page is reachable

```bash
curl -o /dev/null -s -w "%{http_code}" "$BASE_URL/chat.html" | grep -q "200" && echo "PASS: /chat.html returned 200" || echo "FAIL: /chat.html did not return 200"
```

### Check favicon is served

```bash
curl -o /dev/null -s -w "%{http_code}" "$BASE_URL/favicon.ico" | grep -q "200" && echo "PASS: /favicon.ico returned 200" || echo "FAIL: /favicon.ico did not return 200"
```

### Check 404 for unknown page

```bash
curl -o /dev/null -s -w "%{http_code}" "$BASE_URL/nonexistent-page.html" | grep -q "404" && echo "PASS: /nonexistent-page.html returned 404" || echo "FAIL: /nonexistent-page.html did not return 404"
```

### Verify HTML content type on main page

```bash
curl -sI "$BASE_URL/index.html" | grep -i "content-type" | grep -q "text/html" && echo "PASS: Content-Type is text/html" || echo "FAIL: Unexpected Content-Type"
```

### Run all smoke tests in sequence

```bash
#!/bin/bash
BASE_URL="https://hello.joseserver.com"
PASS=0
FAIL=0

run_test() {
  local label="$1"
  local url="$2"
  local expected="$3"

  actual=$(curl -o /dev/null -s -w "%{http_code}" "$url")
  if [ "$actual" == "$expected" ]; then
    echo "PASS: $label (HTTP $actual)"
    ((PASS++))
  else
    echo "FAIL: $label (expected HTTP $expected, got HTTP $actual)"
    ((FAIL++))
  fi
}

run_test "GET /"                    "$BASE_URL/"                      "200"
run_test "GET /index.html"          "$BASE_URL/index.html"            "200"
run_test "GET /chat.html"           "$BASE_URL/chat.html"             "200"
run_test "GET /favicon.ico"         "$BASE_URL/favicon.ico"           "200"
run_test "GET /nonexistent-page"    "$BASE_URL/nonexistent-page.html" "404"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
```

---

## Notes

- Ensure the deployment is fully live before running these tests.
- If `chat.html` does not exist in the project root, remove or update that test case accordingly.
- The 404 test depends on the static file server being configured to return proper 404 responses; some static hosts return 200 with a custom error page — adjust the expected status code if needed.