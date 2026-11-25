# ============================================
# 从 coolsnowwolf/luci 提取 luci-theme-design
# ============================================
EXTRACT_DESIGN_THEME() {
	local BRANCH="openwrt-25.12"
	local TARGET="./package/luci-theme-design"
	local TMP="./.luci_design_tmp"

	echo " "
	echo ">>> Extracting luci-theme-design from coolsnowwolf/luci ($BRANCH)..."

	# 清理旧文件
	rm -rf "$TARGET" "$TMP"
	find ./feeds/luci/ -maxdepth 3 -type d -iname "*luci-theme-design*" -exec rm -rf {} + 2>/dev/null

	# 浅克隆
	git clone --depth=1 --single-branch --branch "$BRANCH" \
		https://github.com/coolsnowwolf/luci.git "$TMP"

	if [ ! -d "$TMP/themes/luci-theme-design" ]; then
		echo ">>> ERROR: luci-theme-design not found in branch $BRANCH!"
		rm -rf "$TMP"
		return 1
	fi

	# 拷贝主题文件
	mkdir -p "$TARGET"
	cp -rf "$TMP/themes/luci-theme-design/." "$TARGET/"

	# 清理临时目录
	rm -rf "$TMP"

	# 刷新 feeds 索引，让构建系统识别新包（解决 dependency which does not exist）
	./scripts/feeds update -a 2>/dev/null || true
	./scripts/feeds install luci-theme-design 2>/dev/null || true

	echo ">>> luci-theme-design extracted successfully to $TARGET"
}
