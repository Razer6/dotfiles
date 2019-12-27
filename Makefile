install-tmux:
	sudo apt install tmux xclip

install-lazy-recon:
	git clone https://github.com/nahamsec/bbht.git
	chmod +x bbht/install.sh
	./bbht/install.sh

symlinks:
	./symlinks.sh

all: install-tmux install-lazy-recon symlinks