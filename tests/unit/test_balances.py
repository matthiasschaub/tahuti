import time
import pytest
from uuid import uuid4

import requests


@pytest.fixture
def expense_uneven(zod, nus, gid, group, member):
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


@pytest.fixture
def expense_thousand(zod, nus, gid, group, member):
    """Add single uneven expenses by ~zod for all"""
    expense = {
        "gid": gid,
        "eid": str(uuid4()),
        "title": "foo",
        "amount": "120000",
        "currency": "EUR",
        "payer": "~zod",
        "date": 1699182124,
        "involves": ["~zod", "~nus"],
    }
    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    zod.put(url, json=expense)


@pytest.mark.usefixtures("group", "member", "expense_uneven")
def test_balances_uneven(zod, nus, gid):
    time.sleep(0.5)
    url = f"/apps/tahuti/api/groups/{gid}/balances"
    for ship in (zod, nus):
        resp = ship.get(url)
        assert resp.status_code == 200
        res = resp.json()
        assert res == [
            {"member": "~zod", "amount": "2", "currency": "EUR"},
            {"member": "~nus", "amount": "-1", "currency": "EUR"},
        ]


@pytest.mark.usefixtures("group", "member", "expense_thousand")
def test_balances_thousand(zod, nus, gid):
    time.sleep(0.5)
    url = f"/apps/tahuti/api/groups/{gid}/balances"
    for ship in (zod, nus):
        resp = zod.get(url)
        assert resp.status_code == 200
        res = resp.json()
        assert res == [
            {"member": "~zod", "amount": "60.000", "currency": "EUR"},
            {"member": "~nus", "amount": "-60.000", "currency": "EUR"},
        ]


@pytest.mark.usefixtures("group_public", "expense")
def test_balances_public(gid):
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/balances"
    resp = requests.get(url)
    assert resp.status_code == 200
    res = resp.json()
    assert res == [
        {"member": "~zod", "amount": "0", "currency": "EUR"},
    ]


@pytest.mark.usefixtures("group", "expense")
def test_balances_unauthorized(gid):
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/balances"
    resp = requests.get(url)
    assert resp.status_code == 401
