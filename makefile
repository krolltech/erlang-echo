compile:
	erlc -o ebin src/*.erl
run:
	erl -pa ebin
