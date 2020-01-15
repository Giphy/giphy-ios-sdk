#!/bin/bash

# remove existing file
rm ios.mdx 2> /dev/null

echo "<div>" >> ios.mdx
echo >> ios.mdx
cat Docs.md >> ios.mdx
echo >> ios.mdx
echo "</div>" >> ios.mdx
