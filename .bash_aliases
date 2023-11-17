push() {
    BRANCH=$(git branch --show-current)
    git push origin $BRANCH
}

upstream() {
    BRANCH=$(git branch --show-current)
    git push --set-upstream origin $BRANCH
}

alias cat=batcat