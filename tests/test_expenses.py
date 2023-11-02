import pytest
from schema import Schema
from time import sleep
from uuid import uuid4


@pytest.fixture
def expense_schema():
    """Response schema"""
    return Schema(
        {
            "id": str,
            "amount": int,
        },
    )


@pytest.fixture
def expenses_schema(expense_schema):
    """Response schema"""
    return Schema([expense_schema])


def test_expense_single(zod, gid, group, eid, expenses_schema):
    """Add single expense by host"""
    expense_given = {
        "id": eid,
        "amount": "100",
    }
    expense_expected = {
        "id": eid,
        "amount": 100,
    }
    url = f"/apps/tahuti/api/groups/{gid}/expenses"

    # PUT /expenses
    response = zod.put(url, json=expense_given)
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
    assert expense_expected in result
    assert result.count(expense_expected) == 1  # idempotent


def test_expense_multi(zod, gid, group, expenses_schema):
    """Add multiple expenses by host"""
    id1 = str(uuid4())
    id2 = str(uuid4())
    url = f"/apps/tahuti/api/groups/{gid}/expenses"

    # PUT /expenses
    response = zod.put(url, json={"id": id1, "amount": "100"})
    response = zod.put(url, json={"id": id2, "amount": "230"})
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


def test_expense_nus(zod, nus, gid, group, member, eid, expenses_schema):
    """Add expense by member ~nus"""
    expense_given = {
        "id": eid,
        "amount": "100",
    }
    expense_expected = {
        "id": eid,
        "amount": 100,
    }
    url = f"/apps/tahuti/api/groups/{gid}/expenses"

    # PUT /expenses
    response = nus.put(url, json=expense_given)
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
    assert expense_expected in result
    assert result.count(expense_expected) == 1  # idempotent

