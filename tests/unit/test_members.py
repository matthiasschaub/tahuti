import pytest
import requests


@pytest.mark.usefixtures("group")
def test_put_members(zod, gid):
    url = f"/apps/tahuti/api/groups/{gid}/members"
    response = zod.put(url, json={"member": "martin"})
    assert response.status_code == 401


@pytest.mark.usefixtures("group_public")
def test_put_members_public(zod, gid):
    url = f"/apps/tahuti/api/groups/{gid}/members"
    response = zod.put(url, json={"member": "martin"})
    assert response.status_code == 200


@pytest.mark.parametrize("name", (None, "", " "))
@pytest.mark.usefixtures("group_public")
def test_put_members_public_invalid_name(zod, gid, name):
    url = f"/apps/tahuti/api/groups/{gid}/members"
    response = zod.put(url, json={"member": name})
    assert response.status_code in (422, 500)


@pytest.mark.parametrize("payload", (None, "", " ", {}, []))
@pytest.mark.usefixtures("group_public")
def test_put_members_public_empty_payload(zod, gid, payload):
    url = f"/apps/tahuti/api/groups/{gid}/members"
    response = zod.put(url, json=payload)
    assert response.status_code in (418, 500)


@pytest.mark.usefixtures("group_public")
def test_put_members_public_unauthorized(nus, gid):
    url = f"/apps/tahuti/api/groups/{gid}/members"
    response = nus.put(url, json={"member": "martin"})
    # TODO: should be 4xx
    assert response.status_code == 500

    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/members"
    response = requests.put(url, json={"member": "martin"})
    assert response.status_code == 401


@pytest.mark.usefixtures("group")
def test_get_members(zod, nus, gid, member_nus):
    for ship in (zod, nus):
        url = f"/apps/tahuti/api/groups/{gid}/members"
        response = ship.get(url)
        assert response.status_code == 200
        result = response.json()
        assert isinstance(result, list)
        assert "~zod" in result
        assert member_nus in result


@pytest.mark.usefixtures("group", "member_nus")
def test_get_members_unauthorized(gid):
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/members"
    response = requests.get(url)
    assert response.status_code == 401


@pytest.mark.usefixtures("group_public")
def test_get_members_public(gid, member_nus, member_martin):
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/members"
    response = requests.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "~zod" in result
    assert "~nus" in result
    assert "martin" in result


@pytest.mark.usefixtures("group")
def test_delete_members(zod, gid, member_nus):
    url = f"/apps/tahuti/api/groups/{gid}/members"
    response = zod.delete(url, json={"member": member_nus})
    assert response.status_code == 501


@pytest.mark.usefixtures("group")
def test_delete_members_unauthorized(gid, member_nus):
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/members"
    response = requests.delete(url, json={"member": member_nus})
    assert response.status_code == 401


@pytest.mark.usefixtures("group_public")
def test_delete_members_public(zod, gid, member_martin):
    url = f"/apps/tahuti/api/groups/{gid}/members"
    response = zod.delete(url, json={"member": member_martin})
    # TODO: should be 200
    assert response.status_code == 501


@pytest.mark.usefixtures("group_public")
def test_delete_members_public_unauthorized(gid, member_martin):
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/members"
    response = requests.delete(url, json={"member": member_martin})
    assert response.status_code == 501
