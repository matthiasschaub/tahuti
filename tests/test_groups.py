from schema import Schema
import pytest


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


def test_groups_invalid(zod):
    # TODO: change status code to expected status code not just internal server error
    url = "/apps/tahuti/api/groups"
    response = zod.put(url, json={})
    assert response.status_code == 500
    response = zod.put(url, json="")
    assert response.status_code == 500
    response = zod.put(url, json=None)
    assert response.status_code == 418


def test_groups_put(zod, gid):
    group = {
        "gid": gid,
        "title": "foo",
        "host": "~zod",
        "currency": "EUR"
    }
    url = "/apps/tahuti/api/groups"

    # PUT
    response = zod.put(url, json=group)
    assert response.status_code == 200

    # GET /groups
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert group in result


def test_groups_get_all(zod, gid, group, groups_schema):
    url = "/apps/tahuti/api/groups"

    # GET /groups
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


def test_groups_delete(zod, gid, group):
    # PUT
    url = f"/apps/tahuti/api/groups/{gid}"
    response = zod.delete(url)
    assert response.status_code == 200

    # GET /groups
    url = f"/apps/tahuti/api/groups"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert group not in result
