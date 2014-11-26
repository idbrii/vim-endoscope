test/build/vader:
	git clone https://github.com/junegunn/vader.vim.git $@

test/build/sensible:
	git clone https://github.com/tpope/vim-sensible.git $@

test/build/textobj-user:
	git clone https://github.com/kana/vim-textobj-user $@

test: test/build/vader test/build/sensible test/build/textobj-user
	cd test \
		&& HOME=/dev/null vim -Nu vimrc -c "Vader! *" > /dev/null

.PHONY: test
