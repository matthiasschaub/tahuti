import requests
import pytest


@pytest.mark.parametrize(
    "json", ({}, "", "~zod", {"invitee": ""}, {"invitee": None}, {"invitee": "zod"})
)
@pytest.mark.usefixtures("group")
def test_invitee_invalid(json, zod, gid):
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    resp = zod.put(url, json=json)
    assert resp.status_code == 500


@pytest.mark.usefixtures("group")
def test_invitee_empty_body(zod, gid):
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    resp = zod.put(url, json=None)
    assert resp.status_code == 418


@pytest.mark.usefixtures("group")
def test_invitees_single(auth, gid):
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

    # GET /members
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/members"
    response = requests.get(url, cookies=auth)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "~nus" not in result


@pytest.mark.usefixtures("group")
def test_invitees_multi(auth, gid):
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
