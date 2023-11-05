from time import sleep


def test_join(zod, nus, gid, group, invitee):
    join = {
        "host": group["host"],
        "gid": gid,
    }
    url = "/apps/tahuti/api/action/join"
    response = nus.post(url, json=join)
    assert response.status_code == 200

    sleep(1)

    # ~zod
    #
    # GET /invitees
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert result == []

    # GET /register
    url = f"/apps/tahuti/api/groups/{gid}/register"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert result == ["~zod", invitee]

    # ~nus
    #
    # GET /groups
    url = f"/apps/tahuti/api/groups/{gid}"
    response = nus.get(url)
    assert response.status_code == 200
    result = response.json()
    assert result == group

    # GET /invitees
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    response = nus.get(url)
    assert response.status_code == 200
    result = response.json()
    assert result == []

    # GET /register
    url = f"/apps/tahuti/api/groups/{gid}/register"
    response = nus.get(url)
    assert response.status_code == 200
    result = response.json()
    assert result == ["~zod", invitee]


def test_join_not_allowed(nus, gid, group):
    join = {
        "host": group["host"],
        "gid": gid,
    }
    url = "/apps/tahuti/api/action/join"
    response = nus.post(url, json=join)
    assert response.status_code == 200
