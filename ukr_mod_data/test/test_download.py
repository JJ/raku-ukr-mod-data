import pytest
from .. import download

@pytest.fixture
def page():
    return download(14,4)

def test_download(page):
    assert page
