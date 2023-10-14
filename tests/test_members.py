import requests


def test_members_invalid(auth, uuid):
    # TODO: change status code to expected status code not just internal server error
    url = f"http://localhost:8080/apps/tahuti/api/groups/{uuid}/members"
    response = requests.put(url, cookies=auth, json={})
    assert response.status_code == 500
    response = requests.put(url, cookies=auth, json="")
    assert response.status_code == 500
    response = requests.put(url, cookies=auth, json=None)
    assert response.status_code == 418
    response = requests.put(url, cookies=auth, json="~zod")
    assert response.status_code == 500
    response = requests.put(url, cookies=auth, json={"member": ""})
    assert response.status_code == 500
    response = requests.put(url, cookies=auth, json={"member": "zod"})
    assert response.status_code == 500


def test_members_single(auth, group):
    """Test PUT and GET requests."""
    uuid = group["gid"]

    # PUT
    url = f"http://localhost:8080/apps/tahuti/api/groups/{uuid}/members"
    response = requests.put(url, cookies=auth, json={"member": "~nus"})
    assert response.status_code == 200
    # idempotent
    response = requests.put(url, cookies=auth, json={"member": "~nus"})
    assert response.status_code == 200

    # GET
    url = f"http://localhost:8080/apps/tahuti/api/groups/{uuid}/members"
    response = requests.get(url, cookies=auth)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "~nus" in result
    assert result.count("~nus") == 1  # idempotent


def test_members_multi(auth, group):
    """Test PUT and GET requests of multiple members."""
    uuid = group["gid"]

    # PUT
    url = f"http://localhost:8080/apps/tahuti/api/groups/{uuid}/members"
    response = requests.put(url, cookies=auth, json={"member": "~nus"})
    response = requests.put(url, cookies=auth, json={"member": "~lus"})

    # GET
    url = f"http://localhost:8080/apps/tahuti/api/groups/{uuid}/members"
    response = requests.get(url, cookies=auth)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "~nus" in result
    assert "~lus" in result
