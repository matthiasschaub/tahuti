from uuid import uuid4
import pytest


@pytest.mark.usefixtures("group", "member", "member_lus")
def test_reimbusements_simple(zod, gid):
    """
    original transactions:      zod -10> nus -10> lus
    minimized transactions:     zod -10> lus
    """
    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    expense = {
        "gid": gid,
        "eid": str(uuid4()),
        "title": "foo",
        "amount": "10",
        "currency": "EUR",
        "payer": "~nus",
        "date": 1699182124,
        "involves": ["~zod"],
    }
    zod.put(url, json=expense)
    expense = {
        "gid": gid,
        "eid": str(uuid4()),
        "title": "foo",
        "amount": "10",
        "currency": "EUR",
        "payer": "~lus",
        "date": 1699182124,
        "involves": ["~nus"],
    }
    zod.put(url, json=expense)

    url = f"/apps/tahuti/api/groups/{gid}/reimbursements"
    resp = zod.get(url)
    assert resp.status_code == 200
    res = resp.json()
    assert res == [{"debitor": "~zod", "amount": 10, "creditor": "~lus"}]
