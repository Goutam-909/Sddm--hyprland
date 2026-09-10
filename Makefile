PREFIX ?= /usr
SRC     = src

# ── Default ───────────────────────────────────────────────────────────────────
all: clean install

# ── Directories ───────────────────────────────────────────────────────────────
prepare:
	mkdir -p $(PREFIX)/share/hypr/sddm
	mkdir -p /etc/sddm.conf.d/

# ── Install ───────────────────────────────────────────────────────────────────
install: clean prepare
	# Main Lua compositor config (replaces the old hyprland.conf)
	@install -D $(SRC)/hyprland.lua $(PREFIX)/share/hypr/sddm/hyprland.lua \
		&& echo "[Installed] $(PREFIX)/share/hypr/sddm/hyprland.lua"

	# Optional personal overrides stub (not overwritten if already present)
	@if [ ! -f $(PREFIX)/share/hypr/sddm/hyprprefs.lua ]; then \
		install -D $(SRC)/hyprprefs.lua $(PREFIX)/share/hypr/sddm/hyprprefs.lua \
			&& echo "[Installed] $(PREFIX)/share/hypr/sddm/hyprprefs.lua"; \
	else \
		echo "[Skipped]   $(PREFIX)/share/hypr/sddm/hyprprefs.lua (already exists, not overwritten)"; \
	fi

	# SDDM drop-in config
	@install -D $(SRC)/sddm-hyprland.conf /etc/sddm.conf.d/sddm-hyprland.conf \
		&& echo "[Installed] /etc/sddm.conf.d/sddm-hyprland.conf"

	# Patch CompositorCommand to point at the Lua config
	@sed -i 's|CompositorCommand=.*|CompositorCommand=start-hyprland -- --config $(PREFIX)/share/hypr/sddm/hyprland.lua|' \
		/etc/sddm.conf.d/sddm-hyprland.conf \
		&& echo "[Patched]   /etc/sddm.conf.d/sddm-hyprland.conf → CompositorCommand"

	# Also patch /etc/sddm.conf if it exists (highest priority)
	@if [ -f /etc/sddm.conf ]; then \
		sed -i 's|CompositorCommand=.*|CompositorCommand=start-hyprland -- --config $(PREFIX)/share/hypr/sddm/hyprland.lua|' \
			/etc/sddm.conf \
			&& echo "[Patched]   /etc/sddm.conf → CompositorCommand"; \
	fi

# ── Verify ────────────────────────────────────────────────────────────────────
verify:
	@echo "=== /etc/sddm.conf (highest priority) ==="
	@grep CompositorCommand /etc/sddm.conf 2>/dev/null || echo "  not present (good)"
	@echo "=== /etc/sddm.conf.d/sddm-hyprland.conf ==="
	@grep CompositorCommand /etc/sddm.conf.d/sddm-hyprland.conf 2>/dev/null || echo "  not set"
	@echo "=== /usr/lib/sddm/sddm.conf.d/default.conf (lowest priority) ==="
	@grep CompositorCommand /usr/lib/sddm/sddm.conf.d/default.conf 2>/dev/null || echo "  not set"
	@echo "=== Lua config present ==="
	@ls -lh $(PREFIX)/share/hypr/sddm/hyprland.lua 2>/dev/null || echo "  MISSING!"

# ── Clean ─────────────────────────────────────────────────────────────────────
clean:
	@rm -rf $(PREFIX)/share/hypr/sddm      && echo "[Cleaned]   $(PREFIX)/share/hypr/sddm"
	@rm -rf $(PREFIX)/share/hyde/sddm      && echo "[Cleaned]   $(PREFIX)/share/hyde/sddm"
	@rm -f  /etc/sddm.conf.d/sddm-hyprland.conf \
		&& echo "[Cleaned]   /etc/sddm.conf.d/sddm-hyprland.conf"

.PHONY: all install prepare clean verify
