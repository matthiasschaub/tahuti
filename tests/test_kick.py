import requests
import time
import pytest


@pytest.mark.parametrize(
    "json", ({}, "", "~nus", {"kick": ""}, {"kick": None}, {"kick": "nus"})
)
@pytest.mark.usefixtures("group", "member")
def test_kick_invalid(json, zod, gid):
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    resp = zod.put(url, json=json)
    assert resp.status_code == 500


@pytest.mark.usefixtures("group", "member")
def test_kick_empty_body(zod, gid):
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    resp = zod.put(url, json=None)
    assert resp.status_code == 418


@pytest.mark.usefixtures("group", "member")
def test_kick_member(zod, gid):
    """Test PUT and GET requests."""

    # PUT /
    url = f"/apps/tahuti/api/groups/{gid}/kick"
    resp = zod.put(url, json="~nus")
    assert resp.status_code == 200
    # idempotent
    resp = zod.put(url, json="~nus")
    assert resp.status_code == 200
    time.sleep(2)

    # GET /invitees
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    resp = zod.get(url)
    assert resp.status_code == 200
    result = resp.json()
    assert isinstance(result, list)
    assert "~nus" not in result

    # GET /register
    url = f"/apps/tahuti/api/groups/{gid}/register"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "~nus" not in result


@pytest.mark.usefixtures("group", "invitee")
def test_kick_invitee(zod, gid):
    """Test PUT and GET requests."""

    # PUT /
    url = f"/apps/tahuti/api/groups/{gid}/kick"
    resp = zod.put(url, json="~nus")
    assert resp.status_code == 200
    # idempotent
    resp = zod.put(url, json="~nus")
    assert resp.status_code == 200
    time.sleep(2)

    # GET /invitees
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    resp = zod.get(url)
    assert resp.status_code == 200
    result = resp.json()
    assert isinstance(result, list)
    assert "~nus" not in result

    # GET /register
    url = f"/apps/tahuti/api/groups/{gid}/register"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "~nus" not in result
