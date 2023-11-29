import time
import pytest
from uuid import uuid4


@pytest.fixture
def expense_1(zod, nus, gid, group, member):
    """Add multiple expenses by ~zod and ~nus for all"""
    for eid, amount in zip((str(uuid4()), str(uuid4())), ("100", "200")):
        expense = {
            "gid": gid,
            "eid": eid,
            "title": "foo",
            "amount": amount,
            "currency": "EUR",
            "payer": "~zod",
            "date": 1699182124,
            "involves": ["~zod", "~nus"],
        }
        url = f"/apps/tahuti/api/groups/{gid}/expenses"
        zod.put(url, json=expense)
    for eid, amount in zip((str(uuid4()), str(uuid4())), ("50", "150")):
        expense = {
            "gid": gid,
            "eid": eid,
            "title": "foo",
            "amount": amount,
            "currency": "EUR",
            "payer": "~nus",
            "date": 1699182124,
            "involves": ["~zod", "~nus"],
        }
        url = f"/apps/tahuti/api/groups/{gid}/expenses"
        nus.put(url, json=expense)


@pytest.fixture
def expense_2(zod, nus, gid, group, member):
    """Add multiple expenses by ~zod for ~nus"""
    for eid, amount in zip((str(uuid4()), str(uuid4())), ("100", "200")):
        expense = {
            "gid": gid,
            "eid": eid,
            "title": "foo",
            "amount": amount,
            "currency": "EUR",
            "payer": "~zod",
            "date": 1699182124,
            "involves": ["~nus"],
        }
        url = f"/apps/tahuti/api/groups/{gid}/expenses"
        zod.put(url, json=expense)


@pytest.mark.usefixtures("group", "member", "expense_1")
def test_balances_1(zod, nus, gid):
    url = f"/apps/tahuti/api/groups/{gid}/balances"

    # GET /balances by ~zod
    resp = zod.get(url)
    assert resp.status_code == 200
    res = resp.json()
    assert res == [
        {"member": "~zod", "amount": "50"},
        {"member": "~nus", "amount": "-50"},
    ]

    # GET /balances by ~nus
    resp = nus.get(url)
    assert resp.status_code == 200
    res = resp.json()
    assert res == [
        {"member": "~zod", "amount": "50"},
        {"member": "~nus", "amount": "-50"},
    ]


@pytest.mark.usefixtures("group", "member", "expense_2")
def test_balances_2(zod, nus, gid):
    url = f"/apps/tahuti/api/groups/{gid}/balances"

    # GET /balances by ~zod
    resp = zod.get(url)
    assert resp.status_code == 200
    res = resp.json()
    assert res == [
        {"member": "~zod", "amount": "300"},
        {"member": "~nus", "amount": "-300"},
    ]

    # GET /balances by ~nus
    resp = nus.get(url)
    assert resp.status_code == 200
    res = resp.json()
    assert res == [
        {"member": "~zod", "amount": "300"},
        {"member": "~nus", "amount": "-300"},
    ]


@pytest.fixture
def expense_3(zod, nus, gid, group, member):
    """Add single uneven expenses by ~zod for all"""
    expense = {
        "gid": gid,
        "eid": str(uuid4()),
        "title": "foo",
        "amount": "3",
        "currency": "EUR",
        "payer": "~zod",
        "date": 1699182124,
        "involves": ["~zod", "~nus"],
    }
    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    zod.put(url, json=expense)


@pytest.mark.usefixtures("group", "member", "expense_3")
def test_balances_3(zod, nus, gid):
    url = f"/apps/tahuti/api/groups/{gid}/balances"

    # GET /balances by ~zod
    resp = zod.get(url)
    assert resp.status_code == 200
    res = resp.json()
    assert res == [
        {"member": "~zod", "amount": "2"},
        {"member": "~nus", "amount": "-1"},
    ]

    # GET /balances by ~nus
    time.sleep(0.5)
    resp = nus.get(url)
    assert resp.status_code == 200
    res = resp.json()
    assert res == [
        {"member": "~zod", "amount": "2"},
        {"member": "~nus", "amount": "-1"},
    ]
