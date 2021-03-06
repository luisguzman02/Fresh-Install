function install_xcode() {
  xcode-select --install
}

function install_homebrew() {
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
}

function install_brews() {
  brew tap phinze/homebrew-cask

  brews=( vim git node the_silver_searcher chruby ruby-install \
          tmux reattach-to-user-namespace phantomjs gnu-sed rename \
          tree wget cmake terminal-notifier weechat brew-cask siege )

  for item in "${brews[@]}"
  do
    if [[ $item == "weechat" ]]; then
      brew install $item --with-perl --with-python --with-ruby
    else
      brew install $item
    fi
  done
}

function install_software() {
  casks=( dropbox box-sync alfred appcleaner right-zoom cloudapp vlc dash xscope \
          cleanmymac vienna-rss google-chrome firefox qlcolorcode qlstephen \
          qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql \
          webp-quicklook suspicious-package )

  for item in "${casks[@]}"
  do
    brew cask install $item
  done
}

function install_php_repl() {
  wget psysh.org/psysh
  chmod +x psysh
  mv ./psysh /usr/local/bin/psysh
}

function install_weechat_notifications() {
  cd $HOME
  sudo gem install weechat terminal-notifier
  curl https://raw.github.com/wallace/weechat-notification-center-rb/master/notification_center.rb > \
        ~/.weechat/ruby/autoload/notification_center.rb

  # We have to install these gems into the system Ruby
  # So simplest way is to move into the home directory
  # We can't run this function until after we've symlinked our dotfiles
}

function switch_to_zsh() {
  chsh -s /bin/zsh
}

function symlink_dotfiles() {
  sync_directory="$HOME/Dropbox/Fresh Install/Shell"

  # Create an Array holding a list of dotfiles to symlink: foo=( bar baz qux )
  # Run a command substitution: $(foo) -> which returns result of sub command being run
  # List all files including those prefixed with a dot: ls -a
  # Then search (grep) for the dotfiles and ignore those we're not interested in: --invert-match
  files=( $(ls -a "$sync_directory" | grep '^\.' | grep --invert-match '\.DS_Store\|\.$') )

  # Loop through the Array creating symlinks
  for file in "${files[@]}"
  do
    ln -s "$sync_directory"/$file $HOME/$file
  done
}

function install_vim_plugins() {
  cd "$HOME/.vim/bundle"

  plugins=( kien/ctrlp.vim jlangston/tomorrow-night-vim tpope/vim-markdown tpope/vim-cucumber \
            scrooloose/syntastic ervandew/supertab tpope/vim-repeat tpope/vim-commentary \
            mileszs/ack.vim tpope/vim-endwise bling/vim-airline edkolev/tmuxline.vim \
            mattn/webapi-vim vim-scripts/Gist.vim mattn/emmet-vim airblade/vim-gitgutter \
            scrooloose/nerdtree tpope/vim-haml tpope/vim-surround othree/html5.vim \
            godlygeek/tabular vim-scripts/camelcasemotion ap/vim-css-color tpope/vim-fugitive \
            sheerun/vim-polyglot vim-scripts/textutil.vim vim-scripts/Tabmerge )

  for item in "${plugins[@]}"
  do
    git clone "https://github.com/$item.git"
  done
}

install_xcode()
install_homebrew()
install_brews()
install_software()
install_php_repl()
switch_to_zsh()

echo "We've installed all the software we can. Check the README to see if there is anything else. \
      Don't forget to execute the symlink_dotfiles function as well once Dropbox is installed. \
      When that's done you can run install_weechat_notifications"
