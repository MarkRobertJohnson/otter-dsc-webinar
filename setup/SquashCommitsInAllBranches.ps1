cd C:\dev\ws\otter-dsc-webinar

$branches = @('dev','stage', 'test', 'prod')
foreach($branch in $branches) {
    git checkout $branches
    git pull
    $sha = "Initial Commit" | git commit-tree "HEAD^{tree}"; git reset $sha; git push --force
}