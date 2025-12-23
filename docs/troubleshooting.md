# Troubleshooting

Common issues and solutions for Spectrum Syntax development.

## Ruby Installation Issues

### macOS SDK or readline errors

If you encounter errors during Ruby installation:

```bash
RUBY_CONFIGURE_OPTS="--with-out-ext=readline" rbenv install 3.2.1
```

Alternatively, use a newer Ruby version:
```bash
rbenv install 3.3.5 && rbenv local 3.3.5
```

### OpenSSL not detected

If OpenSSL isn't found during installation:

```bash
export OPENSSL_DIR="$(brew --prefix openssl@3)"
export CPPFLAGS="-I$OPENSSL_DIR/include"
export LDFLAGS="-L$OPENSSL_DIR/lib"
rbenv install 3.2.1
```

### Wrong Ruby version active

Verify the active Ruby version:
```bash
ruby --version
```

If incorrect, ensure rbenv is properly initialized:
```bash
rbenv local 3.2.1
# OR
rbenv shell 3.2.1
```

Add to your shell profile if needed:
```bash
eval "$(rbenv init -)"
```

## Bundle Issues

### Bundle version mismatch

Always use the specific Bundler version:
```bash
gem install bundler:2.7.1
bundle _2.7.1_ install
```

### Gem installation failures

Try installing with specific paths:
```bash
bundle config set --local path 'vendor/bundle'
bundle _2.7.1_ install
```

## Jekyll Build Issues

### Build fails with plugin errors

Ensure all dependencies are installed:
```bash
bundle _2.7.1_ install
bundle exec jekyll build --trace
```

The `--trace` flag provides detailed error information.

### Port already in use

If port 4000 is already in use:
```bash
# Find and kill the process
lsof -ti:4000 | xargs kill -9

# OR use a different port
bundle exec jekyll serve --port 4001
```

### Liquid syntax errors

Check for:
- Unescaped special characters in front matter
- Unclosed tags or brackets
- Invalid YAML in front matter

## WebP Generation Issues

### Python or Pillow not found

Install Pillow:
```bash
pip3 install Pillow
```

Verify installation:
```bash
python3 -c "import PIL; print(PIL.__version__)"
```

### WebP generation skipped

The WebP task is non-fatal. If it fails:

1. Check Python 3 is available: `which python3`
2. Check Pillow is installed: `pip3 show Pillow`
3. Run manually: `python3 scripts/make_webp.py`

## Git Hook Issues

### Hooks not running

Enable Git hooks:
```bash
git config core.hooksPath .githooks
```

Verify configuration:
```bash
git config --get core.hooksPath
```

### Hook permissions

Ensure hooks are executable:
```bash
chmod +x .githooks/*
```

## GitHub SSH Issues

### Connection timeouts with iCloud Private Relay

Configure `~/.ssh/config` to use port 443:

```
Host github.com
  HostName ssh.github.com
  Port 443
  AddressFamily inet
```

### IPv6 connectivity issues

Force IPv4 in git_push.py:
```bash
python3 scripts/git_push.py --force-ipv4 -m "Update"
```

Or configure SSH to prefer IPv4:
```
Host github.com
  AddressFamily inet
```

### HTTPS to SSH conversion

Switch remote from HTTPS to SSH:
```bash
git remote set-url origin git@github.com:<OWNER>/<REPO>.git
```

Verify:
```bash
git remote -v
```

## Asset Issues

### Missing images

Check for missing assets:
```bash
ruby scripts/check_assets.rb
```

Fix by:
1. Adding the missing file
2. Updating the front matter reference
3. Using a placeholder image

### Broken internal links

After building, validate links:
```bash
bundle exec jekyll build
python3 scripts/check_site_links.py
```

## Test Failures

### Tests not found

Ensure you're in the project root:
```bash
pwd
# Should be: /path/to/Spectrum-Syntax
```

Run tests:
```bash
bundle exec rake test
```

### Python test dependencies missing

Install pytest:
```bash
pip3 install pytest
```

Run Python tests:
```bash
python3 -m pytest tests/unit/
```

## Deployment Issues

### Netlify build fails

Check the build log at:
https://app.netlify.com/sites/spectrumsyntax/deploys

Common causes:
- Missing dependencies in `Gemfile`
- WebP generation errors (usually non-fatal)
- Jekyll build errors (check `netlify.toml` config)

### Build succeeds but site broken

1. Test locally first:
   ```bash
   bundle exec rake webp
   bundle exec jekyll build
   ```

2. Check for missing assets:
   ```bash
   ruby scripts/check_assets.rb
   ```

3. Validate links:
   ```bash
   python3 scripts/check_site_links.py
   ```

## Getting More Help

If you encounter an issue not covered here:

1. Check the [Jekyll documentation](https://jekyllrb.com/docs/)
2. Review [rbenv documentation](https://github.com/rbenv/rbenv)
3. Search GitHub issues in the original [digital-garden-jekyll-template](https://github.com/maximevaillancourt/digital-garden-jekyll-template)

## Next Steps

- See [Setup Guide](setup.md) for installation instructions
- See [Development Guide](development.md) for workflow details
