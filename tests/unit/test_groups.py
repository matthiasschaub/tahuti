from schema import Schema
import pytest
from uuid import uuid4
from time import sleep
import requests


@pytest.fixture
def group_schema():
    """Response schema"""
    return Schema(
        {
            "gid": str,
            "title": str,
            "host": str,
            "currency": str,
            "public": bool,
        },
    )


@pytest.fixture
def groups_schema(group_schema):
    """Response schema"""
    return Schema([group_schema])


@pytest.mark.parametrize("title", (None, "", " "))
def test_groups_put_invalid_title(title, zod):
    group = {
        "gid": str(uuid4()),
        "title": title,
        "currency": "EUR",
        "public": False,
    }
    url = "/apps/tahuti/api/groups"

    # PUT /groups
    response = zod.put(url, json=group)
    assert response.status_code in (422, 500)

    # GET /groups
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert group not in result


@pytest.mark.parametrize("payload", (None, "", " ", {}, []))
def test_groups_put_empty_payload(payload, zod):
    url = "/apps/tahuti/api/groups"
    response = zod.put(url, json=payload)
    assert response.status_code in (418, 500)


def test_groups_get_all(zod, group, groups_schema):
    # GET /groups
    url = "/apps/tahuti/api/groups"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert groups_schema.is_valid(result)
    assert group in result


@pytest.mark.usefixtures("group")
def test_groups_get_all_unauthorized():
    # GET /groups
    url = "http://localhost:8080/apps/tahuti/api/groups"
    response = requests.get(url)
    assert response.status_code == 401


def test_groups_get_single(zod, gid, group, group_schema):
    # GET /groups/{uuid}
    url = f"/apps/tahuti/api/groups/{gid}"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert group_schema.is_valid(result)
    assert result == group


def test_groups_get_single_not_found(zod):
    # GET /groups/{uuid}
    url = f"/apps/tahuti/api/groups/{str(uuid4())}"
    response = zod.get(url)
    # TODO: should be 4xx
    assert response.status_code == 500


def test_groups_delete(zod, gid, group):
    # PUT
    url = f"/apps/tahuti/api/groups/{gid}"
    response = zod.delete(url)
    assert response.status_code == 200

    # GET /groups
    url = "/apps/tahuti/api/groups"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert group not in result


@pytest.mark.usefixtures("member")
def test_groups_delete_unauthorized(zod, nus, gid, group):
    # wait for join
    sleep(0.5)

    # PUT
    url = f"/apps/tahuti/api/groups/{gid}"
    response = nus.delete(url)
    assert response.status_code == 403

    # GET /groups
    url = "/apps/tahuti/api/groups"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert group in result


@pytest.mark.usefixtures("group")
def test_groups_get_private(gid):
    # GET /groups/{uuid}
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}"
    response = requests.get(url)
    assert response.status_code == 401


def test_groups_get_public(gid, group_public, group_schema):
    # GET /groups/{uuid}
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}"
    response = requests.get(url)
    assert response.status_code == 200
    result = response.json()
    assert group_schema.is_valid(result)
    assert result == group_public


@pytest.mark.usefixtures("group")
def test_groups_delete_private(gid):
    # PUT
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}"
    response = requests.delete(url)
    assert response.status_code == 401


@pytest.mark.usefixtures("group_public")
def test_groups_delete_public(gid):
    # PUT
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}"
    response = requests.delete(url)
    assert response.status_code == 401
