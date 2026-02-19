PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
LIBDIR ?= $(PREFIX)/lib/shelltools

SCRIPTS = clean_brew_cache.sh clean_pip_cache.sh clean_node_cache.sh \
		  clean_xcode_cache.sh clean_docker_cache.sh clean_go_cache.sh \
		  clean_cargo_cache.sh clean_gem_cache.sh clean_steam_cache.sh \
		  clean_appletv_cache.sh check_network.sh port_killer.sh dns_lookup.sh

.PHONY: install uninstall

install:
	@echo "Installing MacShellTool..."
	@mkdir -p $(BINDIR)
	@mkdir -p $(LIBDIR)
	@cp $(SCRIPTS) $(LIBDIR)/
	@sed 's|TOOL_DIR="$$HOME/ShellTools"|TOOL_DIR="$(LIBDIR)"|g' tool > $(BINDIR)/tool
	@chmod +x $(BINDIR)/tool
	@chmod +x $(LIBDIR)/*.sh
	@echo "✓ Installed to $(BINDIR)/tool"

uninstall:
	@echo "Uninstalling MacShellTool..."
	@rm -f $(BINDIR)/tool
	@rm -rf $(LIBDIR)
	@echo "✓ Uninstalled"
