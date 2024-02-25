from time import sleep


import requests
import pytest


@pytest.mark.usefixtures("member_nus")
def test_post_leave_member(zod, nus, gid, group):
    """Test leave as member."""
    leave = {
        "host": group["host"],
        "gid": gid,
    }
    url = "/apps/tahuti/api/leave"
    response = nus.post(url, json=leave)
    assert response.status_code == 200
    sleep(0.5)

    # GET /invitees (zod)
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert result == []

    # GET /members (zod)
    url = f"/apps/tahuti/api/groups/{gid}/members"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert result == ["~zod"]

    # GET /castoffs (zod)
    url = f"/apps/tahuti/api/groups/{gid}/castoffs"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert result == ["~nus"]

    # GET /groups (nus)
    url = f"/apps/tahuti/api/groups/{gid}"
    response = nus.get(url)
    assert response.status_code == 500

    # GET /invites (nus)
    url = "/apps/tahuti/api/invites"
    response = nus.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert {"host": group["host"], "gid": gid} not in result


@pytest.mark.usefixtures("invitee_nus")
def test_post_leave_invitee(zod, nus, gid, group):
    """Test leave as invitee (decline invite)."""
    leave = {
        "host": group["host"],
        "gid": gid,
    }
    url = "/apps/tahuti/api/leave"
    response = nus.post(url, json=leave)
    assert response.status_code == 200
    sleep(0.5)

    # GET /invitees (zod)
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    # TODO: should not contain ~nus
    assert result == ["~nus"]

    # GET /castoffs (zod)
    url = f"/apps/tahuti/api/groups/{gid}/castoffs"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert result == []

    # GET /groups (nus)
    url = f"/apps/tahuti/api/groups/{gid}"
    response = nus.get(url)
    assert response.status_code == 500

    # GET /invites (nus)
    url = "/apps/tahuti/api/invites"
    response = nus.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert {"host": group["host"], "gid": gid} not in result


@pytest.mark.usefixtures("member_nus")
def test_post_leave_public(gid, group_public):
    leave = {
        "host": group_public["host"],
        "gid": gid,
    }
    url = "http://localhost:8080/apps/tahuti/api/leave"
    response = requests.post(url, json=leave)
    assert response.status_code == 401


def test_post_leave_not_allowed(zod, nus, gid, group):
    leave = {
        "host": group["host"],
        "gid": gid,
    }
    url = "/apps/tahuti/api/leave"
    response = nus.post(url, json=leave)
    # TODO: Should be 4xx
    assert response.status_code == 200

    # Await leave
    sleep(0.5)

    # GET /members (zod)
    url = f"/apps/tahuti/api/groups/{gid}/members"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert result == ["~zod"]


def test_post_leave_host(zod, gid, group):
    leave = {
        "host": group["host"],
        "gid": gid,
    }
    url = "/apps/tahuti/api/leave"
    response = zod.post(url, json=leave)
    assert response.status_code == 403

    # Await leave
    sleep(0.5)

    # GET /members (zod)
    url = f"/apps/tahuti/api/groups/{gid}"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert result == group
