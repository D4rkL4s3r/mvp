# mvp - Move with Progress

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Bash-4.0+-green.svg)](https://www.gnu.org/software/bash/)

A smart `mv` replacement that shows progress bars, supports previews, and intelligently handles cross-filesystem moves.

## ✨ Features

- 📊 **Progress bars** for cross-filesystem moves
- 👁️ **Preview mode** to see what will happen before executing
- 🔇 **Quiet mode** for silent operations
- 🔍 **Verbose mode** for detailed operation info
- 🎯 **Wildcard support** (`*.txt`, `file*`, etc.)
- 🚀 **Smart detection** - instant move on same filesystem, progress on different ones
- ⏱️ **Time estimation** - ETA and speed calculation
- 📦 **Multiple files** support

## 🚀 Quick Start

### Installation

```bash
# Download the script
curl -o mvp https://raw.githubusercontent.com/D4rkL4s3r/mvp/main/mvp

# Make it executable
chmod +x mvp

# Move to PATH (optional)
sudo mv mvp /usr/local/bin/
```

Or clone the repository:

```bash
git clone https://github.com/D4rkL4s3r/mvp.git
cd mvp
chmod +x mvp
sudo cp mvp /usr/local/bin/
```

### Requirements

- Bash 4.0+
- `rsync` (usually pre-installed on most Linux distributions)
- Standard Unix utilities: `df`, `du`, `find`

## 📖 Usage

```bash
mvp [options] source(s) destination
```

### Options

| Option | Description |
|--------|-------------|
| `-p, --preview` | Preview operations without executing them |
| `-q, --quiet` | Suppress all output including progress bars |
| `-v, --verbose` | Show detailed information about operations |
| `-h, --help` | Display help message |

## 📝 Examples

### Basic usage

```bash
# Move a single file
mvp file.txt /destination/

# Move multiple files
mvp file1.txt file2.txt file3.txt /destination/

# Move with wildcards
mvp *.log /backup/
mvp source/* /destination/
```

### Preview mode

```bash
# See what will happen without actually moving
mvp -p *.txt /documents/

# Output:
# =========================================
# PREVIEW MODE - No files will be moved
# Total size: 2.5MB
# =========================================
# 
# [PREVIEW] Would move: file1.txt -> /documents/file1.txt (1.2MB)
# [PREVIEW] Would move: file2.txt -> /documents/file2.txt (1.3MB)
```

### Quiet mode

```bash
# Silent operation, no progress bars
mvp -q large_file.iso /media/usb/
```

### Verbose mode

```bash
# Get detailed information about the move operation
mvp -v video.mp4 /external/

# Output:
# Moving: video.mp4 -> /external/video.mp4 (1.5GB)
#   → Cross-filesystem, copying with progress...
#   ETA: 2m 30s (10.2MB/s)
```

### Combine options

```bash
# Preview with verbose output
mvp -p -v *.mp4 /videos/

# Quiet and verbose (verbose takes precedence for method info)
mvp -q -v folder/ /backup/
```

## 🔧 How It Works

`mvp` intelligently detects whether the source and destination are on the same filesystem:

### Same Filesystem
- Uses standard `mv` command
- **Instant operation** (just updates metadata)
- No progress bar needed

### Different Filesystems
- Uses `rsync` with `--remove-source-files`
- Shows **progress bar** and **ETA**
- Safely copies then removes source
- Cleans up empty directories

## 📊 Output Examples

### Cross-filesystem move with progress

```bash
$ mvp videos/* /backup/
Total size to move: 2.5GB

Moving: video1.mp4 -> /backup/video1.mp4 (800MB)
  ETA: 2m 15s (6.2MB/s)
          800.00M 100%    6.20MB/s    0:02:08 (xfr#1, to-chk=0/1)

Moving: video2.mp4 -> /backup/video2.mp4 (1.7GB)
  ETA: 4m 30s (6.5MB/s)
            1.70G 100%    6.50MB/s    0:04:22 (xfr#1, to-chk=0/1)

=========================================
Move completed in 7m 12s!
Average speed: 5.9MB/s
Total: 2 | Success: 2 | Failed: 0
=========================================
```

### Same filesystem (instant)

```bash
$ mvp -v file.txt /home/user/documents/
Moving: file.txt -> /home/user/documents/file.txt (125KB)
  → Same filesystem, instant move

=========================================
Move completed in 0s!
Total: 1 | Success: 1 | Failed: 0
=========================================
```

## 🆚 Comparison with Standard `mv`

| Feature | `mv` | `mvp` |
|---------|------|-------|
| Basic move | ✅ | ✅ |
| Progress bar | ❌ | ✅ |
| Preview mode | ❌ | ✅ |
| Time estimation | ❌ | ✅ |
| Speed calculation | ❌ | ✅ |
| Wildcard support | ✅ | ✅ |
| Verbose output | ⚠️ Limited | ✅ Full |

## 🤝 Contributing

Contributions are welcome! Feel free to:

- Report bugs
- Suggest new features
- Submit pull requests
- Improve documentation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with `rsync` for reliable cross-filesystem transfers
- Inspired by the need for better progress feedback in file operations

## 📮 Support

If you encounter any issues or have questions:

- Open an issue on [GitHub](https://github.com/D4rkL4s3r/mvp/issues)
- Check existing issues for solutions

## 🗺️ Roadmap

- [ ] Add color output support
- [ ] Implement parallel transfers for multiple files
- [ ] Add resume capability for interrupted transfers
- [ ] Support for remote destinations (SSH)
- [ ] Configuration file support (~/.mvprc)

---

**Made with ❤️ for the Linux community**
