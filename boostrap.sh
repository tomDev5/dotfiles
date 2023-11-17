required_packages=( bat git vim )

echo "installing required packages..."
for package in "${required_packages[@]}"
do
    if ! dpkg -l $pacakge &>>/dev/null; then
        sudo apt -y install $pacakge
    else
        echo "$package already installed"
    fi
done

TIMESTAMP=$(date +%s)
BACKUP_DIR=~/.old_dotfiles_$TIMESTAMP
CURRENT_DOTFILES=$(find ~ -maxdepth 1 -type f -name "\.*")
mkdir $BACKUP_DIR
echo $CURRENT_DOTFILES | xargs -n1 echo | xargs -i cp {} $BACKUP_DIR/
cp .* ~/ 2>/dev/null