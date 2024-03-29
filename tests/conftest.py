import pytest
from .utils import BaseUrlSession
from uuid import uuid4


@pytest.fixture(scope="session")
def zod():
    """Request session for ~zod which is authenticated"""
    baseUrl = "http://localhost:8080"
    data = {"password": "lidlut-tabwed-pillex-ridrup"}
    with BaseUrlSession(baseUrl) as session:
        session.post("/~/login", data=data)  # perform the login
        yield session


@pytest.fixture(scope="session")
def nus():
    """Request session for ~nus which is authenticated"""
    baseUrl = "http://localhost:8081"
    data = {"password": "bortem-pinwyl-macnyx-topdeg"}
    with BaseUrlSession(baseUrl) as session:
        session.post("/~/login", data=data)  # perform the login
        yield session


@pytest.fixture(scope="session")
def lus():
    """Request session for ~nus which is authenticated"""
    baseUrl = "http://localhost:8082"
    data = {"password": "macsyr-davfed-tanrux-linnec"}
    with BaseUrlSession(baseUrl) as session:
        session.post("/~/login", data=data)  # perform the login
        yield session


# fixtures are module scoped because of hypothesis not working with
# function scoped fixtures
@pytest.fixture(scope="module")
def gid_module():
    return str(uuid4())


@pytest.fixture(scope="module")
def group_module(zod, gid_module) -> dict:
    group = {
        "gid": gid_module,
        "title": "assembly",
        "host": "~zod",
        "currency": "EUR",
        "public": False,
    }
    url = "/apps/tahuti/api/groups"
    zod.put(url, json=group)
    return group


@pytest.fixture(scope="module")
def invitee_module(zod, gid_module, group_module) -> str:
    """Based on `group`. Adds invitee."""
    url = f"/apps/tahuti/api/groups/{gid_module}/invitees"
    zod.put(url, json={"invitee": "~nus"})
    return "~nus"


@pytest.fixture(scope="module")
def invitee_lus_module(zod, gid_module, group_module) -> str:
    """Based on `group`. Adds invite."""
    url = f"/apps/tahuti/api/groups/{gid_module}/invitees"
    zod.put(url, json={"invitee": "~lus"})
    return "~lus"


@pytest.fixture(scope="module")
def member_module(nus, gid_module, group_module, invitee_module) -> str:
    join = {
        "host": group_module["host"],
        "gid": gid_module,
    }
    url = "/apps/tahuti/api/join"
    nus.post(url, json=join)
    return "~nus"


@pytest.fixture(scope="module")
def member_lus_module(lus, gid_module, group_module, invitee_lus_module) -> str:
    join = {
        "host": group_module["host"],
        "gid": gid_module,
    }
    url = "/apps/tahuti/api/join"
    lus.post(url, json=join)
    return "~lus"


# TODO
# @pytest.fixture(scope="session")
# def commit():
#     url = "http://localhost:12321"
#     data = {
#         "source": {"dojo": "+hood/commit %tahuti"},
#         "sink": {"app": "hood"},
#     }
#     requests.post(url, json=data)
#
#
@pytest.fixture
def uuid():
    return str(uuid4())


@pytest.fixture
def eid():
    return str(uuid4())


@pytest.fixture
def gid():
    return str(uuid4())


@pytest.fixture
def group(zod, gid) -> dict:
    group = {
        "gid": gid,
        "title": "assembly",
        "host": "~zod",
        "currency": "EUR",
        "public": False,
    }
    url = "/apps/tahuti/api/groups"
    zod.put(url, json=group)
    return group


@pytest.fixture
def group_public(zod, gid) -> dict:
    group = {
        "gid": gid,
        "title": "assembly",
        "host": "~zod",
        "currency": "EUR",
        "public": True,
    }
    url = "/apps/tahuti/api/groups"
    zod.put(url, json=group)
    return group


# TODO: deprecate in favor of invitee_nus
@pytest.fixture
def invitee(zod, gid, group) -> str:
    """Based on `group`. Adds invitee."""
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    zod.put(url, json={"invitee": "~nus"})
    return "~nus"


@pytest.fixture
def invitee_nus(zod, gid, group) -> str:
    """Based on `group`. Adds invitee."""
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    zod.put(url, json={"invitee": "~nus"})
    return "~nus"


@pytest.fixture
def invitee_public(zod, gid, group_public) -> str:
    """Based on `group`. Adds invitee."""
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    zod.put(url, json={"invitee": "~nus"})
    return "~nus"


@pytest.fixture
def invitee_lus(zod, gid, group) -> str:
    """Based on `group`. Adds invitee."""
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    zod.put(url, json={"invitee": "~lus"})
    return "~lus"


@pytest.fixture
def member_nus(nus, gid, group, invitee_nus) -> str:
    """Based on `group`. Adds invitee."""
    join = {
        "host": group["host"],
        "gid": gid,
    }
    url = "/apps/tahuti/api/join"
    nus.post(url, json=join)
    return "~nus"


# TODO: deprecate in favor of member_nus
@pytest.fixture
def member(nus, gid, group, invitee) -> str:
    """Based on `group`. Adds invitee."""
    join = {
        "host": group["host"],
        "gid": gid,
    }
    url = "/apps/tahuti/api/join"
    nus.post(url, json=join)
    return "~nus"


@pytest.fixture
def member_lus(lus, gid, group, invitee_lus) -> str:
    """Based on `group`. Adds invitee."""
    join = {
        "host": group["host"],
        "gid": gid,
    }
    url = "/apps/tahuti/api/join"
    lus.post(url, json=join)
    return "~nus"


@pytest.fixture
def member_martin(zod, gid, group_public):
    url = f"/apps/tahuti/api/groups/{gid}/members"
    zod.put(url, json={"member": "martin"})
    return "martin"


@pytest.fixture
def kick_nus(zod, gid, group, member_nus):
    url = f"/apps/tahuti/api/groups/{gid}/kick"
    zod.post(url, json={"ship": member_nus})
    assert member_nus


@pytest.fixture
def expense(zod, gid, eid, group):
    """Add single expense by host"""
    expense = {
        "gid": gid,
        "eid": eid,
        "title": "foo",
        "amount": "100",
        "currency": "EUR",
        "payer": "~zod",
        "date": 1699182124,
        "involves": ["~zod"],
    }
    url = f"/apps/tahuti/api/groups/{gid}/expenses"
    response = zod.put(url, json=expense)
    return expense
