import requests
import pytest
from schema import Schema
import uuid

# response schemata
#
group = Schema(
    {
        "title": str,
        "host": str,
        "members": [str],
        "acl": [str]
    },
)
groups = Schema({str: group})

uuid_ = str(uuid.uuid4())


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


def test_redirect_unauthorized():
    url = "http://localhost:8080/apps/tahuti/api"
    response = requests.get(url, allow_redirects=False)
    assert response.status_code == 302


def test_root(auth):
    url = "http://localhost:8080/apps/tahuti/api"
    response = requests.get(url, cookies=auth)
    assert response.status_code == 404
    assert response.content == b"404 - Not Found"


def test_get_foo(auth):
    url = "http://localhost:8080/apps/tahuti/api/foo"
    response = requests.get(url, cookies=auth)
    assert response.status_code == 404
    assert response.content == b"404 - Not Found"


def test_get_groups(auth):
    url = "http://localhost:8080/apps/tahuti/api/groups"
    response = requests.get(url, cookies=auth)
    assert response.status_code == 200
    result = response.json()
    assert groups.is_valid(result)


def test_put_groups_empty(auth):
    url = "http://localhost:8080/apps/tahuti/api/groups"
    response = requests.put(url, cookies=auth, data={})
    assert response.status_code == 418


def test_put_groups_foo_empty(auth):
    url = "http://localhost:8080/apps/tahuti/api/groups/foo"
    response = requests.put(url, cookies=auth, data={})
    assert response.status_code == 418
    response = requests.put(url, cookies=auth, data="")
    assert response.status_code == 418


@pytest.mark.parametrize(
    "uuid,given,expected",
    [
        (
            uuid_,
            {"host": "~zod", "title": "foo", "members": [], "acl": []},
            {uuid_: {"host": "~zod", "title": "foo", "members": [], "acl": []}},
        ),
        (
            uuid_,
            {"host": "~nus", "title": "bar", "members": ["~zod"], "acl": ["~zod"]},
            {uuid_: {"host": "~nus", "title": "bar", "members": ["~zod"], "acl": ["~zod"]}},
        ),
    ],
)
def test_put_groups(auth, uuid, given, expected):
    url = "http://localhost:8080/apps/tahuti/api/groups/" + uuid
    response = requests.put(url, cookies=auth, json=given)
    assert response.status_code == 200
    url = "http://localhost:8080/apps/tahuti/api/groups"
    response = requests.get(url, cookies=auth)
    assert response.status_code == 200
    result = response.json()
    assert groups.is_valid(result)
    # result = response.json()
    # assert result == expected


def test_put_expense(auth):
    url = "http://localhost:8080/apps/tahuti/api/groups/foo/expenses/bar"
    response = requests.put(url, cookies=auth, json={"amount": 3})
    assert response.status_code == 200
    result = response.json()
    assert result == {"bar": {"amount": 3}}
