#!/bin/bash

# Define variables
THEME_DIR="themes"
ZIP_URL="https://github.com/nunocoracao/blowfish/archive/refs/heads/main.zip"
ZIP_FILE="blowfish_main.zip"
EXTRACTED_FOLDER="blowfish-main"
FINAL_FOLDER="blowfish"

# 1. Create themes directory if it doesn't exist and enter it
mkdir -p $THEME_DIR
cd $THEME_DIR || exit

# 2. Delete the old theme folder if it exists
echo "Cleaning up old theme..."
rm -rf "$FINAL_FOLDER"

# 3. Download the latest main branch
echo "Downloading Blowfish theme..."
curl -L $ZIP_URL -o $ZIP_FILE

# 4. Extract the zip file
echo "Extracting..."
unzip -q $ZIP_FILE

# 5. Rename the folder to 'blowfish'
mv "$EXTRACTED_FOLDER" "$FINAL_FOLDER"

# 6. Delete the zip file
rm $ZIP_FILE

# 7. Delete specific subfolders inside the new theme
echo "Removing unnecessary directories (images/ and exampleSite/)..."
rm -rf "$FINAL_FOLDER/images"
rm -rf "$FINAL_FOLDER/exampleSite"

echo "Theme update complete!"