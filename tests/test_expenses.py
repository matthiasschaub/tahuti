import pytest
from time import sleep
from schema import Schema
from uuid import uuid4


@pytest.fixture
def expense_schema():
    """Response schema"""
    return Schema(
        {
            "id": str,
            "title": str,
            "amount": int,
            "currency": str,
            "payer": str,
        },
    )


@pytest.fixture
def expenses_schema(expense_schema):
    """Response schema"""
    return Schema([expense_schema])


@pytest.fixture
def expense(eid): 
    return {
        "id": eid,
        "title": "foo",
        "amount": "100",
        "currency": "EUR",
        "payer": "~zod",
    }


def test_expense_single(zod, gid, group, expense, expenses_schema):
    """Add single expense by host"""
    url = f"/apps/tahuti/api/groups/{gid}/expenses"

    # PUT /expenses
    response = zod.put(url, json=expense)
    assert response.status_code == 200
    # idempotent
    # response = zod.put(url, json=expense)
    # assert response.status_code == 200

    # GET /expenses
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert expenses_schema.is_valid(result)
    assert isinstance(result, list)
    ids = [r["id"] for r in result]
    assert expense["id"] in ids
    assert ids.count(expense["id"]) == 1  # idempotent


def test_expense_multi(zod, gid, group, expense, expenses_schema):
    """Add multiple expenses by host"""
    id1 = str(uuid4())
    id2 = str(uuid4())
    url = f"/apps/tahuti/api/groups/{gid}/expenses"

    # PUT /expenses
    expense["id"] = id1
    response = zod.put(url, json=expense)
    expense["id"] = id2
    response = zod.put(url, json=expense)
    assert response.status_code == 200

    # GET /expenses
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert expenses_schema.is_valid(result)
    assert isinstance(result, list)
    ids = [r["id"] for r in result]
    assert id1 in ids
    assert id2 in ids


def test_expense_nus(zod, nus, gid, group, member, expense, expenses_schema):
    """Add expense by member ~nus"""
    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    sleep(1)
    # PUT /expenses
    response = nus.put(url, json=expense)
    assert response.status_code == 200
    # idempotent
    # response = zod.put(url, json=expense)
    # assert response.status_code == 200
    sleep(1)
    # GET /expenses
    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    assert expenses_schema.is_valid(result)
    assert isinstance(result, list)
    ids = [r["id"] for r in result]
    assert expense["id"] in ids
    assert ids.count(expense["id"]) == 1  # idempotent
