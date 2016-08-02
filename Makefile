.PHONY: all clean

NAME := vagrant-tun
VERSION := 0.1
MAINTAINER := Rick van de Loo <rickvandeloo@gmail.com>
DESCRIPTION := Make sure the tun module is loaded into the kernel

all:
	rake build
test:
	bundle exec rspec spec/
install:
	find pkg/ -name '*.gem' | head -n 1 | xargs vagrant plugin install
clean:
	git clean -xfd

