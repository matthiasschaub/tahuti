import time
import pytest
from uuid import uuid4
from hypothesis import given, strategies, settings


@settings(deadline=None)
@given(
    list1=strategies.lists(strategies.integers(min_value=0)),
    list2=strategies.lists(strategies.integers(min_value=0)),
)
def test_balances(zod, nus, gid_module, group_module, member_module, list1, list2):
    # Setup
    gid = gid_module
    url = f"/apps/tahuti/api/groups/{gid_module}/expenses"
    expenses = []
    for amounts, payer in zip((list1, list2), ("~zod", "~nus")):
        for a in amounts:
            expense = {
                "gid": gid,
                "eid": str(uuid4()),
                "title": "foo",
                "amount": str(a),
                "currency": "EUR",
                "payer": payer,
                "date": 1699182124,
                "involves": ["~zod", "~nus"],
            }
            zod.put(url, json=expense)
            expense["amount"] = a
            expenses.append(expense)

    # Compute balances (net worth of every member)
    balances = []
    for ship in ("~zod", "~nus"):
        debit = 0
        credit = 0
        for e in expenses:
            if ship in e["involves"] and ship == e["payer"]:
                debit += int(e["amount"] / len(e["involves"]))
                credit += e["amount"]
            elif ship in e["involves"]:
                debit += int(e["amount"] / len(e["involves"]))
            elif ship == e["payer"]:
                credit += e["amount"]
            else:
                pass
        balances.append({"member": ship, "amount": int(credit - debit)})

    # GET /balances from ~zod and ~nus
    # Note: Due to update delay in subscription mechanism it does not
    # make sense to check ~nus
    url = f"/apps/tahuti/api/groups/{gid}/balances"
    resp = zod.get(url)
    assert resp.status_code == 200
    res = resp.json()
    res = sorted(res, key=lambda x: x["member"])
    balances = sorted(res, key=lambda x: x["member"])
    for r, b in zip(res, balances):
        r["amount"] = int(r["amount"].replace(".", ""))
        assert r == b


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


@pytest.mark.usefixtures("group", "member", "expense_uneven")
def test_balances_uneven(zod, nus, gid):
    time.sleep(0.5)
    url = f"/apps/tahuti/api/groups/{gid}/balances"
    for ship in (zod, nus):
        resp = ship.get(url)
        assert resp.status_code == 200
        res = resp.json()
        assert res == [
            {"member": "~zod", "amount": "2"},
            {"member": "~nus", "amount": "-1"},
        ]


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


@pytest.mark.usefixtures("group", "member", "expense_thousand")
def test_balances_thousand(zod, nus, gid):
    time.sleep(0.5)
    url = f"/apps/tahuti/api/groups/{gid}/balances"
    for ship in (zod, nus):
        resp = zod.get(url)
        assert resp.status_code == 200
        res = resp.json()
        assert res == [
            {"member": "~zod", "amount": "60.000"},
            {"member": "~nus", "amount": "-60.000"},
        ]
