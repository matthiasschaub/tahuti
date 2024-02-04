import pytest
from hypothesis import given, strategies
from datetime import datetime, timezone
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


@given(
    amount=strategies.integers(min_value=0),
    title=strategies.text(),
    dt=strategies.datetimes(
        min_value=datetime(1970, 1, 1, 0, 0),
        allow_imaginary=False,
    ),
)
@pytest.mark.usefixtures("group_module")
def test_expense_put(
    amount,
    title,
    dt,
    zod,
    gid_module,
    expense_schema,
):
    """Add single expense by host"""
    eid = str(uuid4())
    # convert datetime to unix timestamp in seconds
    dt_utc_aware = dt.replace(tzinfo=timezone.utc)
    ts = int(dt_utc_aware.timestamp())

    expense = {
        "gid": gid_module,
        "eid": eid,
        "title": title,
        "amount": str(amount),
        "currency": "EUR",
        "payer": "~zod",
        "date": ts,
        "involves": ["~zod"],
    }
    url = f"/apps/tahuti/api/groups/{gid_module}/expenses"

    # PUT /expenses
    response = zod.put(url, json=expense)
    assert response.status_code == 200

    # GET /expenses
    response = zod.get(url + "/" + eid)
    assert response.status_code == 200
    result = response.json()
    assert expense_schema.is_valid(result)
    assert pytest.approx(ts, 1) == result.pop("date")
    assert amount == result.pop("amount")
    expense.pop("date")
    expense.pop("amount")
    assert expense == result
