import pytest
import requests


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
def test_put_invitee_invalid(json, zod, gid):
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    resp = zod.put(url, json=json)
    assert resp.status_code == 500


@pytest.mark.usefixtures("group")
def test_put_invitee_empty_body(zod, gid):
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    resp = zod.put(url, json=None)
    assert resp.status_code == 418


@pytest.mark.usefixtures("group")
def test_put_invitees(zod, nus, gid):
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    response = zod.put(url, json={"invitee": "~nus"})
    assert response.status_code == 200


@pytest.mark.usefixtures("invitee_public")
def test_put_invitees_public(gid):
    """Test PUT /invitees in public group with unauthorized requests."""
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/invitees"
    response = requests.put(url, json={"invitee": "~nus"})
    assert response.status_code == 401


def test_get_invitees(zod, nus, gid, group, invitee_nus):
    # GET /invitees
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert invitee_nus in result

    # GET /invites (nus)
    url = "/apps/tahuti/api/invites"
    response = nus.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert group in result


@pytest.mark.usefixtures("group")
def test_get_invitees_multi(zod, gid, invitee_nus, invitee_lus):
    # GET
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert invitee_nus in result
    assert invitee_lus in result


@pytest.mark.usefixtures("invitee_public")
def test_get_invitees_public(gid):
    """Test GET /invitees in public group with unauthorized requests."""
    # GET /invitees
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/invitees"
    response = requests.get(url)
    assert response.status_code == 200

    # GET /invites (nus)
    url = "http://localhost:8081/apps/tahuti/api/invites"
    response = requests.get(url)
    assert response.status_code == 401


@pytest.mark.usefixtures("group")
def test_delete_initees(gid, zod, nus, invitee_nus):
    # DELETE /invitees
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    response = zod.delete(url, json={"invitee": invitee_nus})
    assert response.status_code == 200

    # GET /invitees (zod)
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert invitee_nus not in result

    # GET /invites (nus)
    url = "http://localhost:8081/apps/tahuti/api/invites"
    response = nus.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert invitee_nus not in result
