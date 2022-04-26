.PHONY: clean jgcp requirements flush cache_enable cache_disable yaml

all: apps setup yaml

check: 
	miniwdl check --suppress UnverifiedStruct,Deprecated wdl/pedsnet.wdl 

yaml: 
	$(MAKE) -C wdl yaml

clean:
	$(MAKE) -C utilities clean
	$(MAKE) -C wdl clean

apps:
	$(MAKE) -C utilities

install:
	$(MAKE) -C utilities install

setup:
	pip3 install -r requirements.txt

flush:
	$(info Flushing the WDL run and call caches)
	rm -rf wdl/_LAST 
	rm -rf wdl/20[2-9][2-9][0-9][0-9][0-9][0-9]_*_*
	rm -rf wdl/cromwell-executions
	rm -rf wdl/cromwell-workflow-logs
	rm -rf ~/.cache/miniwdl/*

cache_enable:
	echo "[call_cache]" > ~/.config/miniwdl.cfg
	echo "put = true" >> ~/.config/miniwdl.cfg
	echo "get = true" >> ~/.config/miniwdl.cfg
	echo "dir = ~/.cache/miniwdl" >> ~/.config/miniwdl.cfg

cache_disable:
	echo "[call_cache]" > ~/.config/miniwdl.cfg
	echo "put = false" >> ~/.config/miniwdl.cfg
	echo "get = false" >> ~/.config/miniwdl.cfg
	echo "dir = ~/.cache/miniwdl" >> ~/.config/miniwdl.cfg
