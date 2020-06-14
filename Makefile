MIX_ENV?=dev

deps:
	mix deps.get
	mix deps.compile
compile: deps
	mix compile

token:
export BOT_TOKEN = $(shell cat bot.token)
export API_KEY = $(shell cat googleapi.token)

start: token
	_build/dev/rel/youtube_related_bot/bin/youtube_related_bot daemon

iex: token
	iex -S mix

clean:
	rm -rf _build

purge: clean
	rm -rf deps

stop:
	_build/dev/rel/youtube_related_bot/bin/youtube_related_bot stop

release: deps compile
	mix release

error_logs:
	tail -n 20 -f log/error.log

logs:
	tail -n 20 -f log/debug.log

.PHONY: logs error_logs iex deps compile start purge token deps
