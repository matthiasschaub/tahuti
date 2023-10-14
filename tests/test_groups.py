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


def test_groups_invalid(auth):
    # TODO: change status code to expected status code not just internal server error
    url = "http://localhost:8080/apps/tahuti/api/groups"
    response = requests.put(url, cookies=auth, json={})
    assert response.status_code == 500
    response = requests.put(url, cookies=auth, json="")
    assert response.status_code == 500
    response = requests.put(url, cookies=auth, json=None)
    assert response.status_code == 418


def test_groups_single(auth, uuid, group_schema, groups_schema):
    group = {
        "gid": uuid,
        "title": "foo",
        "host": "~zod",
    }

    # PUT
    url = "http://localhost:8080/apps/tahuti/api/groups"
    response = requests.put(url, cookies=auth, json=group)
    assert response.status_code == 200
    # Test idempotent
    response = requests.put(url, cookies=auth, json=group)
    assert response.status_code == 200

    # GET /groups
    url = "http://localhost:8080/apps/tahuti/api/groups"
    response = requests.get(url, cookies=auth)
    assert response.status_code == 200
    result = response.json()
    assert groups_schema.is_valid(result)
    assert group in result
    assert result.count(group) == 1  # idempotent

    # GET /groups/{uuid}
    url = f"http://localhost:8080/apps/tahuti/api/groups/{uuid}"
    response = requests.get(url, cookies=auth)
    assert response.status_code == 200
    result = response.json()
    assert group_schema.is_valid(result)
    assert result == group
