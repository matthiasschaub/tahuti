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
def commit():
    url = "http://localhost:12321"
    data = {
        "source": {"dojo": "+hood/commit %tahuti"},
        "sink": {"app": "hood"},
    }
    requests.post(url, json=data)


@pytest.fixture
def uuid():
    return str(uuid4())


@pytest.fixture
def group(auth, uuid):
    group = {
        "gid": uuid,
        "title": "foo",
        "host": "~zod",
    }
    url = "http://localhost:8080/apps/tahuti/api/groups"
    requests.put(url, cookies=auth, json=group)
    return group
