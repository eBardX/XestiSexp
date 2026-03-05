XESTI_SEXP_DOCS_DIR?=./docs
XESTI_SEXP_PRODUCT?=XestiSexp

HOSTING_BASE_PATH=$(XESTI_SEXP_PRODUCT)

.PHONY: all build clean lint preview publish reset test update

all: clean update build

build:
	@ swift build -c release

clean:
	@ swift package clean

lint:
	@ swiftlint lint --fix
	@ swiftlint lint

preview:
	@ open "http://localhost:8080/documentation/xestisexp"
	@ swift package --disable-sandbox     \
					preview-documentation \
					--product $(XESTI_SEXP_PRODUCT)

publish:
	@ swift package --allow-writing-to-directory $(XESTI_SEXP_DOCS_DIR) \
					generate-documentation                              \
					--disable-indexing                                  \
					--hosting-base-path $(HOSTING_BASE_PATH)            \
					--output-path $(XESTI_SEXP_DOCS_DIR)                \
					--product $(XESTI_SEXP_PRODUCT)                     \
					--transform-for-static-hosting

reset:
	@ swift package reset

test:
	@ swift test --enable-code-coverage

update:
	@ swift package update
