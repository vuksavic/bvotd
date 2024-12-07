INSTALL_DIR=/usr/local/bin
PASSAGES_DIR=/usr/local/etc
PASSAGES_FILE=$(PASSAGES_DIR)/bible_passages.txt
SCRIPT_FILE=$(INSTALL_DIR)/bvotd.sh
REPO_RAW_URL='https://github.com/scrollmapper/bible_databases/raw/refs/heads/master/formats/txt/SrKDIjekav.txt'

.PHONY: all install clean run

all: install run

install: $(SCRIPT_FILE) $(PASSAGES_FILE)
	@echo "adding script to /etc/rc.local for boot-time execution..."
	@if ! grep -q '/usr/local/bin/bvotd.sh' /etc/rc.local 2>/dev/null; then \
	    echo '/usr/local/bin/bvotd.sh' >> /etc/rc.local; \
	    chmod +x /etc/rc.local; \
	else \
	    echo "already configured to run at boot."; \
	fi

$(SCRIPT_FILE):
	@echo "installing script to $(SCRIPT_FILE)..."
	@mkdir -p $(INSTALL_DIR)
	@cp bin/bvotd.sh $(SCRIPT_FILE)
	@chmod +x $(SCRIPT_FILE)

$(PASSAGES_FILE):
	@if [ ! -f "$(PASSAGES_FILE)" ]; then \
	    echo "downloading bible to $(PASSAGES_FILE)..."; \
	    mkdir -p $(PASSAGES_DIR); \
	    curl -o $(PASSAGES_FILE) $(REPO_RAW_URL); \
	else \
	    echo "bible file already exists at $(PASSAGES_FILE), skipping download"; \
	fi

clean:
	@echo "cleaning up"
	@rm -f $(SCRIPT_FILE) $(PASSAGES_FILE)
	@sed '/bvotd.sh/d' /etc/rc.local

run: $(SCRIPT_FILE)
	@$(SCRIPT_FILE)
