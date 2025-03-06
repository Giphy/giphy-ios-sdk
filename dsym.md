## dSym

Starting with Xcode 16, Apple has introduced stricter checks for native libraries included in frameworks during the App Store upload process. 
This results in warnings about missing debug symbols (dSYM files), even when these symbols are intentionally excluded to reduce the final XCFramework's binary size.

However, we provide dSYM files separately to help you avoid related warnings. 
Additionally, for your convenience, we offer distinct dSYM files specifically tailored for iOS simulators.

### Incorporating dSYM Files into Your Project

The simplest way to integrate these dSYM files into your project is as follows:

1. Download and unzip the dSYM files manually. (You can find links to these files provided with every release starting from version [2.2.15](https://github.com/Giphy/giphy-ios-sdk/releases/tag/2.2.15))

2. Place the unzipped files in a convenient location.

3. Create a new Run Script Build Phase in your Xcode project and insert the following script:

```
DSYM_PATH_DEVICE=""
DSYM_PATH_SIMULATOR=""

if [ "$PLATFORM_NAME" == "iphoneos" ]; then
    echo "Including dSYM in Device build..."
    if [ -d "$DSYM_PATH_DEVICE" ]; then
        cp -R "$DSYM_PATH_DEVICE" "${DWARF_DSYM_FOLDER_PATH}"
    else
        echo "dSYM file not found!"
        exit 1
    fi
elif [ "$PLATFORM_NAME" == "iphonesimulator" ]; then
    echo "Including dSYM in Simulator build..."
    if [ -d "$DSYM_PATH_SIMULATOR" ]; then
        cp -R "$DSYM_PATH_SIMULATOR" "${DWARF_DSYM_FOLDER_PATH}"
    else
        echo "dSYM file not found!"
        exit 1
    fi
else
    echo "Unknown platform: $PLATFORM_NAME"
fi
```

4. Provide paths to the dSYM files by placing them directly inside the empty quotes(""). 
The easiest method is to drag and drop the dSYM files from the Finder application into the script editor, within the appropriate quotes.