TIMESTAMP=$(date +%s)
BACKUP_DIR=~/.old_dotfiles_$TIMESTAMP
CURRENT_DOTFILES=$(find ~ -maxdepth 1 -type f -name "\.*")
mkdir $BACKUP_DIR
echo $CURRENT_DOTFILES | xargs -n1 echo | xargs -i cp {} $BACKUP_DIR/
cp .* ~/ 2>/dev/null