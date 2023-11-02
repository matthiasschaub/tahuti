import pytest
import requests
from .utils import BaseUrlSession
from uuid import uuid4


@pytest.fixture(scope="session")
def auth():
    url = "http://localhost:8080/~/login"
    data = {"password": "lidlut-tabwed-pillex-ridrup"}
    with requests.Session() as session:
        response = session.post(url, data=data)  # perform the login
    return response.cookies


@pytest.fixture(scope="session")
def auth_nus():
    url = "http://localhost:8081/~/login"
    data = {"password": "bortem-pinwyl-macnyx-topdeg"}
    with requests.Session() as session:
        response = session.post(url, data=data)  # perform the login
    return response.cookies


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


# TODO
# @pytest.fixture(scope="session")
# def commit():
#     url = "http://localhost:12321"
#     data = {
#         "source": {"dojo": "+hood/commit %tahuti"},
#         "sink": {"app": "hood"},
#     }
#     requests.post(url, json=data)


@pytest.fixture()
def eid():
    return str(uuid4())


@pytest.fixture()
def gid():
    return str(uuid4())


@pytest.fixture()
def group(zod, gid) -> dict:
    group = {
        "id": gid,
        "title": "assembly",
        "host": "~zod",
    }
    url = "/apps/tahuti/api/groups"
    zod.put(url, json=group)
    return group


@pytest.fixture()
def invitee(zod, gid, group) -> str:
    """Based on `group`. Adds invitee."""
    url = f"/apps/tahuti/api/groups/{gid}/invitees"
    zod.put(url, json={"invitee": "~nus"})
    return "~nus"


@pytest.fixture(scope="module")
def member(nus, group, invitee, gid) -> str:
    """Based on `group`. Adds invitee."""
    join = {
        "host": group["host"],
        "title": "",  # always left empty for /join request
        "gid": gid,
    }
    url = "/apps/tahuti/api/action/join"
    response = nus.post(url, json=join)
