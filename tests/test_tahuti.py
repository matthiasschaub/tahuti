import requests
import pytest

url = "http://localhost:12321"

@pytest.fixture
def commit():
    data = {
        "source": {"dojo": "|commit %tahuti"},
        "sink": {"stdout": None},
    }
    requests.post(url, json=data)


def test_run_dojo():
    url = "http://localhost:12321"
    data = {
        "source": {"dojo": "+hood/commit %base"},
        "sink": {"app": "hood"},
    }
    response = requests.post(url, json=data)
    response.raise_for_status()
    assert response.json() == "ok=%n\n"
