from pathlib import Path


def test_index_contains_title() -> None:
    html = (Path(__file__).resolve().parents[1] / "src" / "index.html").read_text(encoding="utf-8")
    assert "DevOps Cloud Shop" in html
