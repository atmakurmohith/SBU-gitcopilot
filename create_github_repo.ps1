param(
  [string]$repoName = "gitcopilot",
  [string]$owner = $(throw "Please provide an owner (user or org), e.g. -owner 'atmakurmohith'"),
  [ValidateSet('public','private')]
  [string]$visibility = "public"
)

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  Write-Error "GitHub CLI (gh) is not installed. Install it from https://cli.github.com/ and authenticate (gh auth login) before running this script."
  exit 1
}

Write-Output "Creating repository '$owner/$repoName' with visibility '$visibility'..."

# Create the repo on GitHub under the specified owner (user or organization)
$createCmd = "gh repo create $owner/$repoName --$visibility --confirm"
Write-Output "Running: $createCmd"
Invoke-Expression $createCmd
if ($LASTEXITCODE -ne 0) {
  Write-Error "Failed to create repository on GitHub. Please ensure you are authenticated and you have permission to create repos in '$owner'."
  exit $LASTEXITCODE
}

# Prepare remote URL (HTTPS)
$remoteUrl = "https://github.com/$owner/$repoName.git"

if (git remote get-url origin -ErrorAction SilentlyContinue) {
  Write-Output "Updating existing 'origin' remote to $remoteUrl"
  git remote set-url origin $remoteUrl
} else {
  Write-Output "Adding 'origin' remote $remoteUrl"
  git remote add origin $remoteUrl
}

git branch -M main

Write-Output "Pushing 'main' branch to origin..."
git push -u origin main
if ($LASTEXITCODE -ne 0) {
  Write-Error "Failed to push to remote. Check your authentication and permissions."
  exit $LASTEXITCODE
}

Write-Output "Repository '$owner/$repoName' created and pushed."
