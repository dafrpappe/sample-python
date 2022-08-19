# Build
# "make all" for example

# Publish on github
echo "Publishing on Github..."
token="<YOUR GITHUB ACCESS TOKEN>"

# Get the last tag name
tag=$(git describe --tags)

# Get the full message associated with this tag
message="$(git for-each-ref refs/tags/$tag --format='%(contents)')"

# Get the title and the description as separated variables
name=$(echo "$message" | head -n1)
description=$(echo "$message" | tail -n +3)
description=$(echo "$description" | sed -z 's/\n/\\n/g') # Escape line breaks to prevent json parsing problems

# Create a release
release=$(curl -XPOST -H "Authorization:token $token" --data "{\"tag_name\": \"$tag\", \"target_commitish\": \"master\", \"name\": \"$name\", \"body\": \"$description\", \"draft\": false, \"prerelease\": true}" https://api.github.com/repos/<USERNAME>/<REPOSITORY>/releases)

# Extract the id of the release from the creation response
id=$(echo "$release" | sed -n -e 's/"id":\ \([0-9]\+\),/\1/p' | head -n 1 | sed 's/[[:blank:]]//g')

# Upload the artifact
curl -XPOST -H "Authorization:token $token" -H "Content-Type:application/octet-stream" --data-binary @artifact.zip https://uploads.github.com/repos/<USERNAME>/<REPOSITORY>/releases/$id/assets?name=artifact.zip