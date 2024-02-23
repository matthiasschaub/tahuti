import pytest
from time import sleep
import requests
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


@pytest.mark.parametrize("title", ("", " "))
@pytest.mark.usefixtures("group")
def test_expense_put_invalid_title(zod, gid, title):
    expense = {
        "gid": gid,
        "eid": str(uuid4()),
        "title": title,
        "amount": "100",
        "currency": "EUR",
        "payer": "~zod",
        "date": 1699182124,
        "involves": ["~zod"],
    }
    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    # PUT /expenses
    response = zod.put(url, json=expense)
    assert response.status_code == 422


@pytest.mark.parametrize("payload", ("", {}, None))
@pytest.mark.usefixtures("group")
def test_expense_put_empty_body(zod, gid, payload):
    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    # PUT /expenses
    response = zod.put(url, json=payload)
    assert response.status_code in (500, 418)


@pytest.mark.usefixtures("group")
def test_expenses_put(zod, gid):
    expense = {
        "gid": gid,
        "eid": str(uuid4()),
        "title": "foo",
        "amount": "100",
        "currency": "EUR",
        "payer": "~zod",
        "date": 1699182124,
        "involves": ["~zod"],
    }
    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    response = zod.put(url, json=expense)
    assert response.status_code == 200


@pytest.mark.usefixtures("group_public")
def test_expenses_put_public(gid):
    expense = {
        "gid": gid,
        "eid": str(uuid4()),
        "title": "foo",
        "amount": "100",
        "currency": "EUR",
        "payer": "~zod",
        "date": 1699182124,
        "involves": ["~zod"],
    }
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/expenses"
    response = requests.put(url, json=expense)
    assert response.status_code == 200


@pytest.mark.usefixtures("group")
def test_expenses_put_unauthorized(gid):
    expense = {
        "gid": gid,
        "eid": str(uuid4()),
        "title": "foo",
        "amount": "100",
        "currency": "EUR",
        "payer": "~zod",
        "date": 1699182124,
        "involves": ["~zod"],
    }
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/expenses"
    response = requests.put(url, json=expense)
    assert response.status_code == 401


@pytest.mark.usefixtures("group", "member_nus", "expense")
def test_expenses_get(zod, nus, gid, eid, expenses_schema):
    sleep(0.5)
    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    for pal in (zod, nus):
        response = pal.get(url)
        assert response.status_code == 200
        result = response.json()
        assert expenses_schema.is_valid(result)
        assert eid in ([r["eid"] for r in result])


@pytest.mark.usefixtures("group_public", "expense")
def test_expenses_get_public(gid, eid, expenses_schema):
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/expenses"
    response = requests.get(url)
    assert response.status_code == 200
    result = response.json()
    assert expenses_schema.is_valid(result)
    assert eid in ([r["eid"] for r in result])


@pytest.mark.usefixtures("group", "expense")
def test_expenses_get_unauthorized(gid, eid, expenses_schema):
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/expenses"
    response = requests.get(url)
    assert response.status_code == 401


@pytest.mark.usefixtures("group")
def test_expense_put_multi(zod, gid, expense, expenses_schema):
    """Add multiple expenses by host"""
    expense_2 = {
        "gid": gid,
        "eid": str(uuid4()),
        "title": "foo",
        "amount": "100",
        "currency": "EUR",
        "payer": "~zod",
        "date": 1699182124,
        "involves": ["~zod"],
    }
    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    response = zod.put(url, json=expense_2)

    # GET /expenses
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert expenses_schema.is_valid(result)
    assert set([expense["eid"], expense_2["eid"]]) <= set([r["eid"] for r in result])


@pytest.mark.usefixtures("group", "member")
def test_expense_put_by_nus(zod, nus, gid, uuid, expense_schema):
    sleep(0.5)  # wait for successful join
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
    sleep(0.5)  # wait for successful poke

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
    # DELETE /expenses/{eid} by nus
    sleep(0.5)  # wait for successful join
    url = f"/apps/tahuti/api/groups/{gid}/expenses/{eid}"
    response = nus.delete(url)
    assert response.status_code == 200

    # GET /expenses for zod and nus
    sleep(0.5)  # wait for successful poke
    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    for ship in (zod, nus):
        response = ship.get(url)
        assert response.status_code == 200
        result = response.json()
        ids = [r["eid"] for r in result]
        assert eid not in ids


@pytest.mark.usefixtures("group_public", "expense")
def test_expense_delete_public(zod, gid, eid):
    # DELETE /expenses/{eid}
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/expenses/{eid}"
    response = requests.delete(url)
    assert response.status_code == 200

    # GET /expenses
    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    ids = [r["eid"] for r in result]
    assert eid not in ids


@pytest.mark.usefixtures("group", "expense")
def test_expense_delete_unauthorized(gid, eid):
    # DELETE /expenses/{eid}
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/expenses/{eid}"
    response = requests.delete(url)
    assert response.status_code == 401
