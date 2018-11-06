ssh:
	git push
	ssh island 'zsh -s' < ssh.sh
server:
	ruby server.rb
