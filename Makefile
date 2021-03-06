
.PHONY: all
all: usage

.PHONY: usage
usage:
	@cat USAGE

###
### crawler
###

.PHONY: release
release: wget grep aggregate publish

.PHONY: test
test:
	find ./test/ -regex '.*\.sh$$' | xargs -t -n1 bash

.PHONY: wget
wget:
	./crawler/wget.sh data/gov.csv data/pref.csv data/city.csv

.PHONY: grep
grep:
	./crawler/grep.sh

.PHONY: aggregate
aggregate:
	./crawler/aggregate.sh

.PHONY: publish
publish:
	./crawler/publish.sh > ./www-data/index.html

###
### slack-bot
###

# start
.PHONY: slack-start-queue
slack-start-queue:
	./slack-bot/url-queue.sh

.PHONY: slack-start-map
slack-start-map:
	while true; do ./slack-bot/url-map.sh; sleep 1; done

# clear
.PHONY: slack-clear-offer
slack-clear-offer:
	redis-cli DEL vscovid-crawler:offered-members

# check
.PHONY: slack-check-offer
slack-check-offer:
	redis-cli SMEMBERS vscovid-crawler:offered-members

.PHONY: slack-check-queue
slack-check-queue:
	redis-cli KEYS vscovid-crawler:queue-*

.PHONY: slack-check-jobs
slack-check-jobs:
	redis-cli KEYS vscovid-crawler:job-*

.PHONY: slack-check-results
slack-check-results:
	redis-cli KEYS vscovid-crawler:result-*
