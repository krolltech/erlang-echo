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
	erl -make #-smp disable

boot: compile
	erl $(OPTS) -s tcp_link_admin make_boot -s init stop
erl:
	erl -pa ebin +K true

run: compile
	erl $(OPTS)  -name $(NODE) -s tcp_link_app
stop:
	erl $(OPTS)  -name $(NODE) -s tcp_link_app  stop

clean:
	cd ebin && rm *.beam
