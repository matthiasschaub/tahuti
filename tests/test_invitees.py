import requests


def test_invitee_invalid(auth, gid):
    # TODO: change status code to expected status code not just internal server error
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/invitees"
    response = requests.put(url, cookies=auth, json={})
    assert response.status_code == 500
    response = requests.put(url, cookies=auth, json="")
    assert response.status_code == 500
    response = requests.put(url, cookies=auth, json=None)
    assert response.status_code == 418
    response = requests.put(url, cookies=auth, json="~zod")
    assert response.status_code == 500
    response = requests.put(url, cookies=auth, json={"invitee": ""})
    assert response.status_code == 500
    response = requests.put(url, cookies=auth, json={"invitee": "zod"})
    assert response.status_code == 500


def test_invitees_single(auth, gid, group):
    """Test PUT and GET requests."""

    # PUT /invitees
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/invitees"
    response = requests.put(url, cookies=auth, json={"invitee": "~nus"})
    assert response.status_code == 200
    # idempotent
    response = requests.put(url, cookies=auth, json={"invitee": "~nus"})
    assert response.status_code == 200

    # GET /invitees
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/invitees"
    response = requests.get(url, cookies=auth)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "~nus" in result
    assert result.count("~nus") == 1  # idempotent

    # GET /register
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/register"
    response = requests.get(url, cookies=auth)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "~nus" not in result


def test_invitees_multi(auth, gid, group):
    # PUT
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/invitees"
    response = requests.put(url, cookies=auth, json={"invitee": "~nus"})
    response = requests.put(url, cookies=auth, json={"invitee": "~lus"})

    # GET
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/invitees"
    response = requests.get(url, cookies=auth)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "~nus" in result
    assert "~lus" in result
