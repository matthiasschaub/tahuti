import requests
from time import sleep
import pytest
from uuid import uuid4


@pytest.mark.parametrize(
    "payload",
    (
        {},
        "",
        "~nus",
        {"ship": ""},
        {"ship": None},
        {"ship": "nus"},
    ),
)
@pytest.mark.usefixtures("group", "member")
def test_kick_invalid_payload(zod, gid, payload):
    url = f"/apps/tahuti/api/groups/{gid}/kick"
    resp = zod.post(url, json=payload)
    assert resp.status_code == 500


@pytest.mark.usefixtures("group", "member")
def test_kick_empty_payload(zod, gid):
    url = f"/apps/tahuti/api/groups/{gid}/kick"
    resp = zod.post(url, json=None)
    assert resp.status_code == 418


@pytest.mark.usefixtures("group")
def test_post_kick(zod, gid, member_nus):
    # POST /kick (zod)
    url = f"/apps/tahuti/api/groups/{gid}/kick"
    resp = zod.post(url, json={"ship": member_nus})
    assert resp.status_code == 200


@pytest.mark.usefixtures("group")
def test_post_kick_unautherized(nus, gid, member_nus):
    # POST /kick (zod)
    sleep(0.5)
    url = f"/apps/tahuti/api/groups/{gid}/kick"
    resp = nus.post(url, json={"ship": member_nus})
    assert resp.status_code == 403


@pytest.mark.usefixtures("group")
def test_post_kick_public(nus, gid, member_nus):
    # POST /kick (zod)
    sleep(0.5)
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/kick"
    resp = requests.post(url, json={"ship": member_nus})
    assert resp.status_code == 401


def test_kick_get_members(
    zod,
    gid,
    group,
    kick_nus,
):
    # GET /members (zod)
    url = f"/apps/tahuti/api/groups/{gid}/members"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "~nus" not in result


def test_kick_get_castoffs(
    zod,
    gid,
    group,
    kick_nus,
):
    # GET /castoffs (zod)
    url = f"/apps/tahuti/api/groups/{gid}/castoffs"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert isinstance(result, list)
    assert "~nus" in result


def test_kick_put_expenses(
    zod,
    nus,
    gid,
    group,
    kick_nus,
):
    eid = str(uuid4())
    expense = {
        "gid": gid,
        "eid": eid,
        "title": "foo",
        "amount": "100",
        "currency": "EUR",
        "payer": "~zod",
        "date": 1699182124,
        "involves": ["~zod"],
    }
    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    response = nus.put(url, json=expense)
    assert response.status_code == 200

    response = zod.get(url)
    assert response.status_code == 200
    assert eid not in [r["eid"] for r in response.json()]


def test_kick_delete_expenses(
    zod,
    nus,
    gid,
    group,
    kick_nus,
    expense,
    eid,
):
    url = f"/apps/tahuti/api/groups/{gid}/expenses/{eid}"
    response = nus.delete(url)
    assert response.status_code == 200

    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    response = zod.get(url)
    assert response.status_code == 200
    assert eid in [r["eid"] for r in response.json()]
