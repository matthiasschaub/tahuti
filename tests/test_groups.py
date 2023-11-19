from schema import Schema
from hypothesis import given, strategies
import pytest
from uuid import uuid4


@pytest.fixture
def group_schema():
    """Response schema"""
    return Schema(
        {
            "gid": str,
            "title": str,
            "host": str,
            "currency": str,
        },
    )


@pytest.fixture
def groups_schema(group_schema):
    """Response schema"""
    return Schema([group_schema])


@given(title=strategies.text(), uuid=strategies.uuids())
def test_groups_put(uuid, title, zod):
    group = {"gid": str(uuid), "title": title, "host": "~zod", "currency": "EUR"}
    url = "/apps/tahuti/api/groups"
    # PUT /groups
    response = zod.put(url, json=group)
    assert response.status_code == 200

    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    # because of example shrinking by hypothesis multiple groups with the same
    # UUID but different title are tried out but not found in result since only
    # the first one is successfully created
    #
    # assert group in result
    assert str(uuid) in [r["gid"] for r in result]


@pytest.mark.parametrize("host", (None, "", "foo", "~nus"))
def test_groups_put_invalid_host(host, zod):
    group = {"gid": str(uuid4()), "title": "foo", "host": host, "currency": "EUR"}
    url = "/apps/tahuti/api/groups"

    # PUT /groups
    response = zod.put(url, json=group)
    # TODO: should be 4xx
    assert response.status_code == 200

    # GET /groups
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert group not in result


def test_groups_put_invalid(zod):
    # TODO: change status code to expected status code not just internal server error
    url = "/apps/tahuti/api/groups"
    response = zod.put(url, json={})
    assert response.status_code == 500
    response = zod.put(url, json="")
    assert response.status_code == 500
    response = zod.put(url, json=None)
    assert response.status_code == 418


def test_groups_get_all(zod, group, groups_schema):
    # GET /groups
    url = "/apps/tahuti/api/groups"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert groups_schema.is_valid(result)
    assert group in result


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
    # PUT
    url = f"/apps/tahuti/api/groups/{gid}"
    response = nus.delete(url)
    # TODO: should be 403 Forbidden
    assert response.status_code == 200

    # GET /groups
    url = "/apps/tahuti/api/groups"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert group in result
