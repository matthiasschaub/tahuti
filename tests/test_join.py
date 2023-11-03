import requests
from time import sleep


def test_join(auth, auth_nus, gid, group, invitee):
    join = {
        "host": group["host"],
        "title": "",  # always left empty for /join request
        "id": gid,
    }
    url = "http://localhost:8081/apps/tahuti/api/action/join"
    response = requests.post(url, cookies=auth_nus, json=join)
    assert response.status_code == 200

    sleep(2)

    # ~zod
    #
    # GET /invitees
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/invitees"
    response = requests.get(url, cookies=auth)
    assert response.status_code == 200
    result = response.json()
    assert result == []

    # GET /members
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/register"
    response = requests.get(url, cookies=auth)
    assert response.status_code == 200
    result = response.json()
    assert result == [invitee]

    # ~nus
    #
    # GET /groups
    url = f"http://localhost:8081/apps/tahuti/api/groups/{gid}"
    response = requests.get(url, cookies=auth_nus)
    assert response.status_code == 200
    result = response.json()
    assert result == group

    # GET /invitees
    url = f"http://localhost:8081/apps/tahuti/api/groups/{gid}/invitees"
    response = requests.get(url, cookies=auth_nus)
    assert response.status_code == 200
    result = response.json()
    assert result == []

    # GET /register
    url = f"http://localhost:8081/apps/tahuti/api/groups/{gid}/register"
    response = requests.get(url, cookies=auth_nus)
    assert response.status_code == 200
    result = response.json()
    assert result == [invitee]


def test_join_not_allowed(auth_nus, gid, group):
    join = {
        "host": group["host"],
        "title": "",  # always left empty for /join request
        "id": gid,
    }
    url = "http://localhost:8081/apps/tahuti/api/action/join"
    response = requests.post(url, cookies=auth_nus, json=join)
    assert response.status_code == 200
