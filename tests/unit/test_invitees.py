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
def test_invitees_single(zod, nus, gid):
    """Test PUT and GET requests."""

    # PUT /invitees
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    response = zod.put(url, json={"invitee": "~nus"})
    assert response.status_code == 200

    # GET /invitees
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/invitees"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "~nus" in result

    # GET /members
    url = f"/apps/tahuti/api/groups/{gid}/members"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "~nus" not in result

    # GET /invites (nus)
    url = "/apps/tahuti/api/invites"
    response = nus.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert {
        "host": "~zod",
        "currency": "EUR",
        "title": "assembly",
        "gid": gid,
    } in result


@pytest.mark.usefixtures("group")
def test_invitees_multi(zod, gid):
    # PUT
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    response = zod.put(url, json={"invitee": "~nus"})
    response = zod.put(url, json={"invitee": "~lus"})

    # GET
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "~nus" in result
    assert "~lus" in result
