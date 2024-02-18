import pytest


@pytest.mark.parametrize(
    "json",
    (
        {},
        "",
        "~zod",
        {"member": ""},
        {"member": None},
        {"member": " "},
    ),
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


def test_invitees_single(zod, nus, gid, group):
    """Test PUT and GET requests."""

    # PUT /invitees
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    response = zod.put(url, json={"invitee": "~nus"})
    assert response.status_code == 200

    # GET /invitees
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "~nus" in result

    # GET /invites (nus)
    url = "/apps/tahuti/api/invites"
    response = nus.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert group in result


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
