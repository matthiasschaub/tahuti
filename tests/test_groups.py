import requests
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


def test_groups(zod, auth, uuid, group_schema, groups_schema):
    group = {
        "gid": uuid,
        "title": "foo",
        "host": "~zod",
    }
    url = "/apps/tahuti/api/groups"

    # PUT
    response = zod.put(url, json=group)
    assert response.status_code == 200
    # Test idempotent
    response = zod.put(url, json=group)
    assert response.status_code == 200

    # GET /groups
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert groups_schema.is_valid(result)
    assert group in result
    assert result.count(group) == 1  # idempotent

    # GET /groups/{uuid}
    url = f"/apps/tahuti/api/groups/{uuid}"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert group_schema.is_valid(result)
    assert result == group
