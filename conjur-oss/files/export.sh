#!/bin/bash

echo "Sidecar: Waiting for main application's HTTP endpoint at http://localhost:8080/..."

while ! curl --fail-with-body --silent --output /dev/null http://localhost:8080/; do
    echo "Sidecar: Main application HTTP endpoint not ready yet, sleeping..."
    sleep 10
done
echo "Sidecar: Main application HTTP endpoint is ready!"

TOKEN_EXPIRATION=$(date -d "now + {{ .Values.exportAPIkey.ttl }}" +%s)
TOKEN_VALUE=$(echo "{\"account\":\"conjur\", \"sub\":\"admin\", \"exp\":$TOKEN_EXPIRATION}" | socat - UNIX-CONNECT:"/run/authn-local/.socket")
echo "Sidecar: Generated Conjur token value"

echo "Sidecar: Proceeding to create Kubernetes Secret using curl..."

# Kubernetes API access details (provided by the ServiceAccount mount)
SERVICEACCOUNT_DIR="/var/run/secrets/kubernetes.io/serviceaccount"
TOKEN=$(cat "${SERVICEACCOUNT_DIR}/token")
NAMESPACE=$(cat "${SERVICEACCOUNT_DIR}/namespace")
CACERT="${SERVICEACCOUNT_DIR}/ca.crt"
KUBERNETES_SERVICE_HOST=$KUBERNETES_SERVICE_HOST # Injected by Kubernetes
KUBERNETES_SERVICE_PORT=$KUBERNETES_SERVICE_PORT # Injected by Kubernetes

API_SERVER_URL="https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}"
SECRETS_API_PATH="/api/v1/namespaces/${NAMESPACE}/secrets"

SECRET_NAME="conjur-oss-conjur-admin-token"
SECRET_KEY="token.json"

# Base64 encode the secret value
# Using tr -d '\n' to remove newline characters added by base64 on some systems
ENCODED_VALUE=$(echo -n "${TOKEN_VALUE}" | base64 | tr -d '\n')

# Construct the JSON payload for the Secret
read -r -d '' JSON_PAYLOAD <<EOF
{
  "apiVersion": "v1",
  "kind": "Secret",
  "metadata": {
    "name": "${SECRET_NAME}"
  },
  "type": "Opaque",
  "data": {
    "${SECRET_KEY}": "${ENCODED_VALUE}"
  }
}
EOF

echo "Sidecar: removing any existing Secret with the same name..."
curl -X DELETE \
  -H "Authorization: Bearer ${TOKEN}" \
  --cacert "${CACERT}" \
  --silent \
  --output /dev/null \
  --write-out "%{http_code}\n" \
  "${API_SERVER_URL}${SECRETS_API_PATH}/${SECRET_NAME}" | grep -q "200" && echo "Sidecar: Successfully deleted existing Secret '$SECRET_NAME'." || echo "Sidecar: No existing Secret '$SECRET_NAME' to delete or deletion failed."

echo "Sidecar: Attempting to create Secret '$SECRET_NAME' in namespace '$NAMESPACE'..."
HTTP_CODE=$(curl -X POST \
-H "Authorization: Bearer ${TOKEN}" \
--json "${JSON_PAYLOAD}" \
--cacert "${CACERT}" \
--silent \
--output /dev/null \
--write-out "%{http_code}\n" \
"${API_SERVER_URL}${SECRETS_API_PATH}")

if [[ "$HTTP_CODE" =~ ^2 ]]; then # Check for 2xx success codes
  echo "Sidecar: Successfully created Secret '$SECRET_NAME'. HTTP Status: $HTTP_CODE"
elif [[ "$HTTP_CODE" == "409" ]]; then # 409 Conflict means it already exists
  echo "Sidecar: Secret '$SECRET_NAME' already exists. HTTP Status: $HTTP_CODE"
else
  echo "Sidecar: Failed to create Secret '$SECRET_NAME'. HTTP Status: $HTTP_CODE"
fi

echo "Sidecar: Post-main-app-startup tasks completed."

# Keep the sidecar container running indefinitely to prevent it from exiting and causing
# the control plane to try and restart it.
tail -f /dev/null