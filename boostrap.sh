mapfile -t required_packages < <(cat apt_packages.txt)
mapfile -t vscode_extensions < <(cat vscode_extensions.txt)

echo "installing required packages..."
for package in "${required_packages[@]}"
do
    if ! dpkg -l $pacakge &>>/dev/null; then
        sudo apt -y install $pacakge
    else
        echo -e "\t$package already installed"
    fi
done

if [ $(which code) ]; then
    echo "installing vscode extensions..."
    for extension in "${vscode_extensions[@]}"
    do
        if [ $(code --list-extensions | grep $extension | wc -l) = 0 ]; then
            code --install-extension $extension
        else
            echo -e "\t$extension already installed"
        fi
    done
fi

TIMESTAMP=$(date +%s)
BACKUP_DIR=~/.old_dotfiles_$TIMESTAMP
CURRENT_DOTFILES=$(find ~ -maxdepth 1 -type f -name "\.*")
mkdir $BACKUP_DIR
echo $CURRENT_DOTFILES | xargs -n1 echo | xargs -i cp {} $BACKUP_DIR/
cp .* ~/ 2>/dev/null