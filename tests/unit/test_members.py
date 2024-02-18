import pytest


@pytest.mark.usefixtures("group_public")
def test_member_single(zod, gid):
    """Test PUT and GET requests."""

    # PUT /members
    url = f"/apps/tahuti/api/groups/{gid}/members"
    response = zod.put(url, json={"member": "hos"})
    assert response.status_code == 200

    # GET /members
    url = f"/apps/tahuti/api/groups/{gid}/members"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "hos" in result
