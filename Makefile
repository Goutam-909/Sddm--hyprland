# Define the PREFIX variable
PREFIX ?= /usr
SRC=src

# Default target
all: clean install

prepare:
	mkdir -p $(PREFIX)/share/hypr/sddm
	mkdir -p /etc/sddm.conf.d/

install: clean prepare
	@install -D $(SRC)/hyprland.conf $(PREFIX)/share/hypr/sddm/hyprland.conf && echo "[Installed] $(PREFIX)/share/hypr/sddm/hyprland.conf"
	@install -D $(SRC)/sddm-hyprland.conf /etc/sddm.conf.d/sddm-hyprland.conf && echo "[Installed] /etc/sddm.conf.d/sddm-hyprland.conf"
	@sed -i 's|CompositorCommand=.*|CompositorCommand=start-hyprland -- --config $(PREFIX)/share/hypr/sddm/hyprland.conf|' /etc/sddm.conf.d/sddm-hyprland.conf && echo "[default sddm conf] $(PREFIX)/share/hypr/sddm/hyprland.conf"
	@if [ -f /etc/sddm.conf ]; then \
		sed -i 's|CompositorCommand=.*|CompositorCommand=start-hyprland -- --config $(PREFIX)/share/hypr/sddm/hyprland.conf|' /etc/sddm.conf && echo "[patched /etc/sddm.conf] CompositorCommand"; \
	fi

verify:
	@echo "=== /etc/sddm.conf (highest priority) ==="
	@grep CompositorCommand /etc/sddm.conf 2>/dev/null || echo "  not present (good)"
	@echo "=== /etc/sddm.conf.d/sddm-hyprland.conf ==="
	@grep CompositorCommand /etc/sddm.conf.d/sddm-hyprland.conf 2>/dev/null || echo "  not set"
	@echo "=== /usr/lib/sddm/sddm.conf.d/default.conf (lowest priority) ==="
	@grep CompositorCommand /usr/lib/sddm/sddm.conf.d/default.conf 2>/dev/null || echo "  not set"

clean:
	@rm -rf $(PREFIX)/share/hypr/sddm && echo "[cleaned] $(PREFIX)/share/hypr/sddm"
	@rm -rf $(PREFIX)/share/hyde/sddm && echo "[cleaned] $(PREFIX)/share/hyde/sddm"
	@rm -rf /etc/sddm.conf.d/sddm-hyprland.conf && echo "[cleaned] /etc/sddm.conf.d/sddm-hyprland.conf"

.PHONY: all install prepare clean verify
