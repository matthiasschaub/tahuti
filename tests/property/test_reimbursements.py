import random
import pytest
from uuid import uuid4
from hypothesis import given, strategies, settings


@pytest.mark.usefixtures(
    "group_module",
    "member_module",
    "member_lus_module",
)
# @settings(max_examples=150, deadline=None)
@settings(deadline=None)
@given(
    amounts1=strategies.lists(strategies.integers(min_value=0)),
    amounts2=strategies.lists(strategies.integers(min_value=0)),
    amounts3=strategies.lists(strategies.integers(min_value=0)),
)
def test_balances(
    zod,
    gid_module,
    amounts1,
    amounts2,
    amounts3,
):
    # PUT /expenses
    # Set up expenses
    gid = gid_module
    url = f"/apps/tahuti/api/groups/{gid_module}/expenses"
    members = ("~zod", "~nus", "~lus")
    amounts = (amounts1, amounts2, amounts3)
    for payer, a in zip(members, amounts):
        for v in a:
            expense = {
                "gid": gid,
                "eid": str(uuid4()),
                "title": "foo",
                "amount": str(v),
                "currency": "EUR",
                "payer": payer,
                "date": 1699182124,
                "involves": [random.choice(members)],
            }
            resp = zod.put(url, json=expense)
            assert resp.status_code == 200

    # GET /reimbursements
    # balance suggested reimbursements out
    url = f"/apps/tahuti/api/groups/{gid}/reimbursements"
    resp = zod.get(url)
    assert resp.status_code == 200
    res = resp.json()
    for r in res:
        expense = {
            "gid": gid,
            "eid": str(uuid4()),
            "title": "foo",
            "amount": str(r["amount"]),
            "currency": "EUR",
            "payer": r["debitor"],
            "date": 1699182124,
            "involves": [r["creditor"]],
        }
        url = f"/apps/tahuti/api/groups/{gid_module}/expenses"
        zod.put(url, json=expense)

    # GET /balances
    # after paying suggested reimbursements balances should be 0
    url = f"/apps/tahuti/api/groups/{gid}/balances"
    resp = zod.get(url)
    assert resp.status_code == 200
    res = resp.json()
    for r in res:
        assert 0 == int(r["amount"].replace(".", ""))
