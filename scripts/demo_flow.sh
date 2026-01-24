#!/bin/bash

echo "🚀 Starting Proof-of-Culture Demo Flow"

echo ""
echo "1️⃣ Health Check"
curl http://localhost:8000/
echo ""

echo ""
echo "2️⃣ Fetch Events"
curl http://localhost:8000/events
echo ""

echo ""
echo "3️⃣ Simulate QR Proof Verification"
curl -X POST http://localhost:8000/proof/verify \
  -H "Content-Type: application/json" \
  -d '{"qr":"event_college_fest:123456789:testnonce"}'
echo ""

echo ""
echo "✅ Demo flow completed"
