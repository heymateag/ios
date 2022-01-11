# Heymate iOS Source Code Compilation Guide


# Compilation Guide

1. Install Xcode (directly from https://developer.apple.com/download/more or using the App Store).
2. Clone the project from GitHub:

```
git clone --recursive -j8 https://github.com/TelegramMessenger/Telegram-iOS.git
```

3. Download Bazel 4.0.0

```
mkdir -p $HOME/bazel-dist
cd $HOME/bazel-dist
curl -O -L https://github.com/bazelbuild/bazel/releases/download/4.0.0/bazel-4.0.0-darwin-x86_64
mv bazel-* bazel
```

Verify that it's working

```
chmod +x bazel
./bazel --version
```

4. Adjust configuration parameters

```
mkdir -p $HOME/telegram-configuration
cp -R build-system/example-configuration/* $HOME/telegram-configuration/
```

- Modify the values in `variables.bzl`
- Replace the provisioning profiles in `provisioning` with valid files

5. (Optional) Create a build cache directory to speed up rebuilds

```
mkdir -p "$HOME/telegram-bazel-cache"
```

5. Build the app

```
python3 build-system/Make/Make.py \
    --bazel="$HOME/bazel-dist/bazel" \
    --cacheDir="$HOME/telegram-bazel-cache" \
    build \
    --configurationPath="$HOME/telegram-configuration" \
    --buildNumber=100001 \
    --configuration=release_universal
```

6. (Optional) Generate an Xcode project

```
python3 build-system/Make/Make.py \
    --bazel="$HOME/bazel-dist/bazel" \
    --cacheDir="$HOME/telegram-bazel-cache" \
    generateProject \
    --configurationPath="$HOME/telegram-configuration" \
    --disableExtensions
```

It is possible to generate a project that does not require any codesigning certificates to be installed: add `--disableProvisioningProfiles` flag:
```
python3 build-system/Make/Make.py \
    --bazel="$HOME/bazel-dist/bazel" \
    --cacheDir="$HOME/telegram-bazel-cache" \
    generateProject \
    --configurationPath="$HOME/telegram-configuration" \
    --disableExtensions \
    --disableProvisioningProfiles
```
7.Replace the submodules,Main Bazel build file and Resources folders from this project into your final cloned project
