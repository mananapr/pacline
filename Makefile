PKG = pacline
SRC = build/pacline.love
OUT = build/www
REMOTE = pajeet
TMPDIR = /tmp/$(PKG)-deploy
DESTDIR = /var/www/$(PKG)

.PHONY: all
all: $(OUT)

$(OUT): $(SRC)
	@mkdir -p $(OUT)
	@npx love.js $(SRC) $(OUT) --title $(PKG) -c
	@cp love.css $(OUT)/theme/

$(SRC):
	@rm -rf build && mkdir -p build
	@zip -r $(SRC) . -x "build/*" ".git/*" ".gitignore"

.PHONY: clean
clean:
	@rm -rf build

.PHONY: deploy
deploy: all
	@rsync -av --delete $(OUT)/ $(REMOTE):$(TMPDIR)/
	@ssh $(REMOTE) "sudo cp -r $(TMPDIR)/* $(DESTDIR)/ && sudo chown -R caddy:caddy $(DESTDIR)"
	@echo "deployed 🚀"
