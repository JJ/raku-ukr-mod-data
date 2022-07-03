import pytest
from .. import download, driver

@pytest.fixture
def page():
    return download(14,4)

def test_driver():
    assert driver

def test_download(page):
    assert page
