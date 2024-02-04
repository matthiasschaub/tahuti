import pytest
from time import sleep
from schema import Schema
from uuid import uuid4


@pytest.fixture(scope="session")
def expense_schema():
    """Response schema"""
    return Schema(
        {
            "gid": str,
            "eid": str,
            "title": str,
            "amount": int,
            "currency": str,
            "payer": str,
            "date": int,
            "involves": list,
        },
    )


@pytest.fixture(scope="session")
def expenses_schema(expense_schema):
    """Response schema"""
    return Schema([expense_schema])


@pytest.mark.usefixtures("group")
def test_expense_put_multi(zod, gid, expenses_schema):
    """Add multiple expenses by host"""
    expense = {
        "gid": gid,
        "eid": "",
        "title": "foo",
        "amount": "100",
        "currency": "EUR",
        "payer": "~zod",
        "date": 1699182124,
        "involves": ["~zod"],
    }
    id1 = str(uuid4())
    id2 = str(uuid4())
    url = f"/apps/tahuti/api/groups/{gid}/expenses"

    # PUT /expenses
    expense["eid"] = id1
    response = zod.put(url, json=expense)
    expense["eid"] = id2
    response = zod.put(url, json=expense)
    assert response.status_code == 200

    # GET /expenses
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert expenses_schema.is_valid(result)
    assert set([id1, id2]) <= set([r["eid"] for r in result])


@pytest.mark.usefixtures("group", "member")
def test_expense_put_by_nus(zod, nus, gid, uuid, expense_schema):
    """Add expense by member"""
    sleep(1)  # wait for successful join
    expense = {
        "gid": gid,
        "eid": uuid,
        "title": "foo",
        "amount": "100",
        "currency": "EUR",
        "payer": "~zod",
        "date": 1699182124,
        "involves": ["~zod"],
    }
    url = f"/apps/tahuti/api/groups/{gid}/expenses"

    # PUT /expenses by nus
    response = nus.put(url, json=expense)
    assert response.status_code == 200
    sleep(1)  # wait for successful poke

    # GET /expenses for zod
    for ship in (zod, nus):
        response = ship.get(url + "/" + uuid)
        assert response.status_code == 200
        result = response.json()
        assert expense_schema.is_valid(result)
        expense["amount"] = 100
        assert expense == result


@pytest.mark.usefixtures("group", "expense")
def test_expense_delete(zod, gid, eid):
    """Delete single expense by host"""
    # DELETE /expenses/{eid}
    url = f"/apps/tahuti/api/groups/{gid}/expenses/{eid}"
    response = zod.delete(url)
    assert response.status_code == 200

    # GET /expenses
    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    ids = [r["eid"] for r in result]
    assert eid not in ids


@pytest.mark.usefixtures("group", "member", "expense")
def test_expense_delete_by_nus(zod, nus, gid, eid):
    """Delete single expense by member"""
    # DELETE /expenses/{eid} by nus
    sleep(1)  # wait for successful join
    url = f"/apps/tahuti/api/groups/{gid}/expenses/{eid}"
    response = nus.delete(url)
    assert response.status_code == 200

    # GET /expenses for zod and nus
    sleep(1)  # wait for successful poke
    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    for ship in (zod, nus):
        response = ship.get(url)
        assert response.status_code == 200
        result = response.json()
        ids = [r["eid"] for r in result]
        assert eid not in ids
