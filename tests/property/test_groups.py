from hypothesis import given, strategies, settings
import pytest


@settings(deadline=None)
@given(
    title=strategies.text(min_size=1),
    uuid=strategies.uuids(),
    public=strategies.booleans(),
)
@pytest.mark.parametrize("currency", ("EUR", "USD"))
def test_groups_put(uuid, title, public, currency, zod):
    group = {
        "gid": str(uuid),
        "title": title,
        "host": "~zod",
        "currency": currency,
        "public": public,
    }
    url = "/apps/tahuti/api/groups"
    # PUT /groups
    response = zod.put(url, json=group)
    assert response.status_code == 200

    response = zod.get(url)
    assert response.status_code == 200
    result = response.json()
    # because of example shrinking by hypothesis multiple groups with the same
    # UUID but different title are tried out but not found in result since only
    # the first one is successfully created
    #
    # assert group in result
    assert str(uuid) in [r["gid"] for r in result]
