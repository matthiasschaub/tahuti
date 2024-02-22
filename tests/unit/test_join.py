from time import sleep

import requests
import pytest


@pytest.mark.usefixtures("invitee_nus")
def test_post_join(nus, gid, group):
    join = {
        "host": group["host"],
        "gid": gid,
    }
    url = "/apps/tahuti/api/join"
    response = nus.post(url, json=join)
    assert response.status_code == 200


@pytest.mark.usefixtures("member_nus")
def test_post_join_public(gid, group_public):
    join = {
        "host": group_public["host"],
        "gid": gid,
    }
    url = "http://localhost:8080/apps/tahuti/api/join"
    response = requests.post(url, json=join)
    assert response.status_code == 401


def test_post_join_not_allowed(zod, nus, gid, group):
    join = {
        "host": group["host"],
        "gid": gid,
    }
    url = "/apps/tahuti/api/join"
    response = nus.post(url, json=join)
    # TODO: Should be 4xx
    assert response.status_code == 200

    # Await join
    sleep(0.5)

    # GET /members (zod)
    url = f"/apps/tahuti/api/groups/{gid}/members"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert result == ["~zod"]


def test_join(zod, nus, gid, group, member_nus):
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
    assert result == ["~zod", member_nus]

    # GET /groups (nus)
    url = f"/apps/tahuti/api/groups/{gid}"
    response = nus.get(url)
    assert response.status_code == 200
    result = response.json()
    assert result == group

    # GET /invitees (nus)
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    response = nus.get(url)
    assert response.status_code == 200
    result = response.json()
    assert result == []

    # GET /members (nus)
    url = f"/apps/tahuti/api/groups/{gid}/members"
    response = nus.get(url)
    assert response.status_code == 200
    result = response.json()
    assert result == ["~zod", member_nus]

    # GET /invites (nus)
    url = "/apps/tahuti/api/invites"
    response = nus.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert {"host": group["host"], "gid": gid} not in result
