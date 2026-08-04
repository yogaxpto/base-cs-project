.PHONY: lint format typecheck test check

lint:
	ruff check .

format:
	ruff format .

typecheck:
	mypy .

test:
	pytest --cov --cov-report=term-missing

check: lint typecheck test
