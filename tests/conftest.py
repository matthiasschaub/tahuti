import pytest
import requests
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


# TODO
# @pytest.fixture(scope="session")
# def commit():
#     url = "http://localhost:12321"
#     data = {
#         "source": {"dojo": "+hood/commit %tahuti"},
#         "sink": {"app": "hood"},
#     }
#     requests.post(url, json=data)


@pytest.fixture(scope="session")
def uuid():
    return str(uuid4())


@pytest.fixture(scope="session")
def gid(uuid):
    return uuid

@pytest.fixture(scope="session")
def group(auth, gid) -> dict:
    group = {
        "gid": gid,
        "title": "assembly",
        "host": "~zod",
    }
    url = "http://localhost:8080/apps/tahuti/api/groups"
    requests.put(url, cookies=auth, json=group)
    return group


@pytest.fixture(scope="session")
def member(auth, gid, group) -> str:
    """Based on `group`. Adds members."""
    url = f"http://localhost:8080/apps/tahuti/api/groups/{gid}/members"
    requests.put(url, cookies=auth, json={"member": "~nus"})
    return "~nus"
