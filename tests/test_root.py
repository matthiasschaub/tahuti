import requests


def test_root(auth):
    url = "http://localhost:8080/apps/tahuti/api"
    response = requests.get(url, cookies=auth)
    assert response.status_code == 404
    assert response.content == b"404 - Not Found"
