# Setup Guide

This guide covers installation and initial setup for local development.

## Requirements

- Ruby 3.2.1
- Bundler 2.7.1
- Python 3 (for WebP generation and link checking)
- Pillow (Python library for image processing)

## Installation

### 1. Install rbenv and Ruby

On macOS, use rbenv for Ruby version management:

```bash
brew install rbenv ruby-build
```

### 2. Install Ruby 3.2.1

Install the Ruby version specified in `.ruby-version`:

```bash
rbenv install 3.2.1
```

#### Troubleshooting Ruby Installation

If you encounter macOS SDK or readline errors:
```bash
RUBY_CONFIGURE_OPTS="--with-out-ext=readline" rbenv install 3.2.1
# OR use a newer Ruby version:
rbenv install 3.3.5 && rbenv local 3.3.5
```

If OpenSSL isn't detected:
```bash
export OPENSSL_DIR="$(brew --prefix openssl@3)"
export CPPFLAGS="-I$OPENSSL_DIR/include"
export LDFLAGS="-L$OPENSSL_DIR/lib"
rbenv install 3.2.1
```

### 3. Set Ruby Version and Install Dependencies

```bash
rbenv local 3.2.1   # or `rbenv shell 3.2.1`
gem install bundler:2.7.1
bundle _2.7.1_ install
```

### 4. Install Python Dependencies (Optional)

For WebP generation and link checking:

```bash
pip3 install Pillow
```

## Verify Installation

Build the site to verify everything is set up correctly:

```bash
bundle exec jekyll build
```

Or start the development server:

```bash
bundle exec jekyll serve
```

The site will be available at http://localhost:4000.

## Next Steps

- See [Development Guide](development.md) for local development workflow
- See [Troubleshooting](troubleshooting.md) for common issues
