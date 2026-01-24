from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Welcome to the FastAPI application!"}  # Adjust this based on your actual root response

def test_authentication():
    response = client.post("/auth/login", json={"username": "testuser", "password": "testpass"})
    assert response.status_code == 200
    assert "access_token" in response.json()

def test_create_event():
    response = client.post("/events/", json={"name": "Test Event", "date": "2023-10-01"})
    assert response.status_code == 201
    assert response.json()["name"] == "Test Event"

def test_list_events():
    response = client.get("/events/")
    assert response.status_code == 200
    assert isinstance(response.json(), list)  # Ensure the response is a list

def test_verify_proof():
    response = client.post("/proof/verify", json={"proof_id": "12345"})
    assert response.status_code == 200
    assert response.json()["valid"] is True  # Adjust based on your actual proof verification logic