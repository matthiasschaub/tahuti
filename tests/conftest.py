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


@pytest.fixture(scope="module")
def uuid():
    return str(uuid4())


@pytest.fixture(scope="module")
def gid(uuid):
    return uuid


@pytest.fixture(scope="module")
def group(auth, gid) -> dict:
    group = {
        "gid": gid,
        "title": "assembly",
        "host": "~zod",
    }
    url = "http://localhost:8080/apps/tahuti/api/groups"
    requests.put(url, cookies=auth, json=group)
    return group


@pytest.fixture(scope="module")
def invitee(auth, gid, group) -> str:
    """Based on `group`. Adds invitee."""
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/invitees"
    requests.put(url, cookies=auth, json={"invitee": "~nus"})
    return "~nus"
