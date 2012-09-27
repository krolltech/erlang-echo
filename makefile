LOAD_PATH = \
	ebin \
	$(NULL)

NAME = tcp_link
HOST = `hostname`
NODE = $(NAME)@$(HOST)

OPTS = \
	-pa $(LOAD_PATH) \
			+A 8 +K true +P 120000 \ # -smp disable \
		-detached  \
		-noshell \
		$(NULL)

compile:
	erl -make

erl:
	erl -pa ebin +K true

run: compile
	erl $(OPTS)  -name $(NODE) -s tcp_link_app start -detached

demon:
	erl $(OPTS)  -name $(NODE) -s tcp_link_app start
stop:
	erl $(OPTS)  -name $(NODE) -s tcp_link_app  stop

clean:
	cd ebin && rm *.beam
