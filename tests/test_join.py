import requests
from time import sleep


def test_join(auth_nus, gid, group, member):
    join = {
        "host": group["host"],
        "title": "",  # always left empty for /join request
        "gid": gid,
    }
    url = "http://localhost:8081/apps/tahuti/api/action/join"
    response = requests.post(url, cookies=auth_nus, json=join)
    assert response.status_code == 200

    sleep(5)

    # GET group
    url = f"http://localhost:8081/apps/tahuti/api/groups/{gid}"
    response = requests.get(url, cookies=auth_nus)
    assert response.status_code == 200
    result = response.json()
    assert result == group

    # GET members
    url = f"http://localhost:8081/apps/tahuti/api/groups/{gid}/members"
    response = requests.get(url, cookies=auth_nus)
    assert response.status_code == 200
    result = response.json()
    assert result == [member]
