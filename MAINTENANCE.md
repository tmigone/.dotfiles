# macOS Maintenance Spec

A comprehensive guide to keeping your Mac clean and performant over time.

---

## Tools Overview

| Tool | Install | Purpose |
|------|---------|---------|
| Mole | `brew install mole` | Deep cleaning, uninstall, disk analysis, optimization |
| Homebrew | (already installed) | Package management cleanup |
| Docker | (if used) | Container/image cleanup |
| Git | (already installed) | Repository maintenance |

---

## Package Management

### Upgrade Homebrew packages
**Action:** `brew upgrade`
**Frequency:** Weekly
**Notes:** Updates all installed formulae and casks to latest versions.

### Remove old package versions
**Action:** `brew cleanup`
**Frequency:** Monthly
**Notes:** Removes old versions of installed formulae. By default keeps the latest version only. Use `brew cleanup -n` to dry-run first. Use `brew cleanup --prune=all` to remove all cache files including downloads.

### Remove orphaned dependencies
**Action:** `brew autoremove`
**Frequency:** Monthly
**Notes:** Removes formulae that were installed as dependencies but are no longer needed by any installed formula.

### Audit installed packages against Brewfile
**Action:** `brew bundle cleanup --file=~/path/to/Brewfile`
**Frequency:** Quarterly
**Notes:** Lists formulae/casks installed but not in your Brewfile. Add `--force` to actually uninstall them. This catches stuff you installed manually and forgot about.

### Reverse audit: find stale Brewfile entries
**Action:** `brew bundle check --file=~/path/to/Brewfile`
**Frequency:** Quarterly
**Notes:** Verifies all entries in Brewfile are satisfied. Manually review your Brewfile periodically - you may have entries for tools you no longer use.

### Clean npm/pnpm cache
**Action (manual):** `pnpm store prune` or `npm cache clean --force`
**Action (Mole):** Included in `mo clean`
**Mole behavior:** Clears npm/node cache directories. No retention policy - clears all cached packages. Safe because packages re-download on demand.
**Frequency:** Monthly

### Clean Cargo cache
**Action:** `cargo cache --autoclean` (requires `cargo install cargo-cache`)
**Frequency:** Quarterly
**Notes:** Removes old crate versions, keeps latest. Alternative: manually delete `~/.cargo/registry/cache` and `~/.cargo/git/db` for full reset.

### Prune unused fnm/node versions
**Action:** `fnm list` then `fnm uninstall <version>` for unused ones
**Frequency:** Quarterly
**Notes:** Keep only Node versions you actively use. Projects will specify their version in `.nvmrc` or `package.json`.

---

## Caches

### App caches (`~/Library/Caches`)
**Action (Mole):** `mo clean`
**Mole behavior:** Clears user app caches. Uses whitelist system (`mo clean --whitelist`) to protect specific caches. Has `--dry-run` to preview. Clears everything not whitelisted - no age-based retention.
**Frequency:** Monthly
**Notes:** Can easily grow to 10-50GB. Safe to delete - apps rebuild caches on demand. Some apps may feel slower temporarily.

### App logs (`~/Library/Logs`)
**Action (Mole):** `mo clean`
**Mole behavior:** Removes application log files. No retention policy - removes all logs.
**Frequency:** Monthly
**Notes:** Useful for debugging but rarely needed long-term. Review before deleting if you're troubleshooting something.

### Homebrew cache
**Action (manual):** `brew cleanup --prune=all`
**Action (Mole):** `mo clean`
**Mole behavior:** Clears Homebrew download cache.
**Frequency:** Monthly
**Notes:** Downloads are re-fetched when needed. Can save several GB.

---

## Development Artifacts

### Stale node_modules
**Action (Mole):** `mo purge`
**Mole behavior:** Scans for `node_modules`, `target`, `build`, `dist` directories. **Retention policy: projects modified <7 days ago are marked but unselected by default.** Configurable scan paths via `mo purge --paths` (stored in `~/.config/mole/purge_paths`). Interactive selection before deletion.
**Frequency:** Monthly
**Notes:** Can easily recover 10-50GB on a dev machine. Run `npm install`/`pnpm install` to restore.

### Build directories
**Action (Mole):** `mo purge`
**Mole behavior:** Same as above - covers `dist`, `build`, `.next`, `target`.
**Frequency:** Monthly

### Git garbage collection
**Action:** Run `git gc` in each repository, or script it:
```bash
find ~/code -name ".git" -type d -execdir git gc --aggressive --prune=now \;
```
**Frequency:** Quarterly
**Notes:** Compresses git objects, removes unreachable objects. Can significantly reduce `.git` folder sizes.

### Docker cleanup
**Action:**
```bash
docker system prune -a          # Remove all unused images, containers, networks
docker volume prune             # Remove unused volumes (careful - data loss!)
docker builder prune            # Remove build cache
```
**Frequency:** Monthly
**Notes:** `-a` removes all unused images, not just dangling ones. Check `docker system df` first to see usage.

### Python virtual environments
**Action:** Find and delete old venvs:
```bash
find ~/code -name ".venv" -o -name "venv" -type d
```
**Frequency:** Quarterly
**Notes:** Recreate with `python -m venv .venv` when needed. Not covered by Mole.

---

## Storage Hogs

### Large files detection
**Action (Mole):** `mo analyze` then press `L` for large files view
**Mole behavior:** Visual disk explorer with treemap. Shows size by directory. `L` key shows large files list. Can delete directly with `backspace`.
**Frequency:** Quarterly

### Duplicate files
**Action:** Use `fdupes` (`brew install fdupes`) or a GUI tool like Gemini
**Frequency:** Quarterly
**Notes:** Not covered by Mole. Be careful with hardlinks and intentional duplicates.

### Downloads folder
**Action:** Manual review. Consider a script to auto-archive files older than 30/60/90 days.
**Frequency:** Monthly
**Notes:** Not auto-cleaned by Mole. Set up a maintenance script or manual habit.

### Desktop clutter
**Action:** Manual organization or scripted cleanup
**Frequency:** Weekly
**Notes:** macOS Stacks can help organize. Consider a "inbox zero" policy for Desktop.

### Screenshots
**Action:** Review `~/Desktop` or custom screenshot location. Delete old screenshots.
**Frequency:** Monthly
**Notes:** Can set screenshot location with `defaults write com.apple.screencapture location ~/Screenshots`.

### Old DMGs and installers
**Action (Mole):** `mo installer`
**Mole behavior:** Scans Downloads, Desktop, Homebrew cache for `.dmg`, `.pkg` files. Interactive selection for deletion.
**Frequency:** Monthly

### Trash
**Action (Mole):** `mo clean`
**Mole behavior:** Empties trash as part of cleanup.
**Action (manual):** Finder > Empty Trash, or `rm -rf ~/.Trash/*`
**Frequency:** Weekly
**Notes:** Consider `defaults write com.apple.finder FXRemoveOldTrashItems -bool true` to auto-delete items after 30 days.

---

## System

### System logs
**Action (Mole):** `mo clean` and `mo optimize`
**Mole behavior:** Clears diagnostic and crash logs from `/var/log` and other locations.
**Frequency:** Monthly

---

## Applications

### Unused apps removal
**Action (Mole):** `mo uninstall`
**Mole behavior:** Shows installed apps, lets you select for removal. Automatically finds and removes "52 related files across 12 locations" including: Application Support, Caches, Preferences, Logs, WebKit storage, Cookies, Extensions, Plugins, Launch Agents/Daemons, Containers. Interactive preview before deletion.
**Frequency:** Quarterly

### Leftover files from uninstalled apps
**Action (Mole):** Run `mo uninstall` for any remaining apps you want fully removed
**Action (manual):** Search in `~/Library/Application Support/`, `~/Library/Preferences/`, `~/Library/Caches/` for app names
**Frequency:** After uninstalling apps

### Login items
**Action:** System Settings > General > Login Items. Remove unwanted apps.
**Frequency:** Quarterly
**Notes:** Not auto-cleaned by Mole. Review both "Open at Login" and "Allow in the Background" sections.

### Launch agents
**Action:** Review `~/Library/LaunchAgents/` and `/Library/LaunchAgents/`
**Mole behavior:** Removes launch agents as part of app uninstall, but doesn't audit orphaned ones.
**Frequency:** Quarterly
**Notes:** Orphaned launch agents from manually deleted apps can cause errors on boot.

### Browser extensions
**Action:** Manually review in each browser's extension settings
**Frequency:** Quarterly
**Notes:** Extensions can slow browsing and pose security risks. Remove unused ones.

### Menu bar apps
**Action:** Manual audit. Hold Cmd and drag off unwanted icons.
**Frequency:** Quarterly
**Notes:** Too many menu bar apps consume resources and clutter the interface.

---

## Security & Privacy

### App permissions audit
**Action:** System Settings > Privacy & Security. Review each category.
**Frequency:** Quarterly
**Notes:** Check Full Disk Access, Accessibility, Screen Recording, etc. Revoke for apps you no longer use.

### Check for credentials in shell history
**Action:**
```bash
grep -iE "(password|secret|api_key|token|AWS_|GITHUB_)=" ~/.zsh_history
history | grep -iE "(curl.*-u|mysql.*-p|export.*(KEY|SECRET|TOKEN))"
```
**Frequency:** Quarterly
**Notes:** Common mistakes: passing secrets as CLI args, exporting env vars in plain text. Consider adding sensitive patterns to `HISTIGNORE` or using `setopt HIST_IGNORE_SPACE` and prefixing sensitive commands with a space.

---

## Configuration Drift

### Diff dotfiles vs repo
**Action:**
```bash
cd ~/.dotfiles
git status
git diff
```
**Frequency:** Monthly
**Notes:** Check if you've made local changes that should be committed, or if you've drifted from your preferred config.

### Compare installed brews vs Brewfile
**Action:**
```bash
brew bundle cleanup --file=~/.dotfiles/Brewfile  # lists untracked installs
brew bundle check --file=~/.dotfiles/Brewfile    # checks if Brewfile is satisfied
```
**Frequency:** Monthly
**Notes:** Helps you notice tools you've installed ad-hoc and should either add to Brewfile or remove.

### System preferences audit
**Action:** Review System Settings periodically. Consider scripting preferences with `defaults write`.
**Frequency:** Quarterly
**Notes:** Your `macos.sh` captures some preferences. Check if others have drifted.

### Shell history audit
**Action:** `history | grep "brew install\|cargo install\|npm install -g\|pip install"`
**Frequency:** Monthly
**Notes:** Find tools you installed manually and forgot to add to your setup scripts.

---

## Performance

### Startup items review
**Action:** System Settings > General > Login Items
**Frequency:** Quarterly
**Notes:** Fewer startup items = faster boot and more available resources.

---

## Network

### Flush DNS cache
**Action (Mole):** `mo optimize`
**Mole behavior:** Flushes DNS cache completely. **No retention - clears all cached DNS entries.** Entries rebuild automatically as you browse.
**Action (manual):** `sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder`
**Frequency:** When having DNS issues, or monthly as maintenance

### Saved WiFi networks
**Action:** System Settings > Wi-Fi > Advanced (or click details on current network) > review known networks
**Frequency:** Yearly
**Notes:** Remove networks for places you no longer visit (hotels, old offices, etc.)

---

## Browser Specific

### Clear browsing data
**Action (Mole):** `mo clean`
**Mole behavior:** Clears Chrome, Safari, Firefox caches. Does not clear passwords, bookmarks, or history by default - focuses on cache/temp data.
**Frequency:** Monthly

---

## Git/Code

### Prune stale remote branches
**Action:**
```bash
git remote prune origin        # Remove refs to deleted remote branches
git branch -vv | grep 'gone]'  # Find local branches with deleted remotes
```
**Frequency:** Monthly

### Find repos with unpushed work
**Action:**
```bash
find ~/code -name ".git" -execdir bash -c 'git log @{u}.. --oneline 2>/dev/null | head -1 && pwd' \;
```
**Frequency:** Weekly
**Notes:** Don't lose work in unpushed commits.

### Find repos with uncommitted changes
**Action:**
```bash
find ~/code -name ".git" -execdir bash -c '[[ -n $(git status -s) ]] && pwd' \;
```
**Frequency:** Weekly
**Notes:** Review and either commit or discard stale changes.



----
brew doctor