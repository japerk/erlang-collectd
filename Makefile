ERL=erl

all: src

src: FORCE
	@$(ERL) -pa ebin -make

plt:
	@dialyzer --build_plt --plt .plt -q -r .

check: src
	@dialyzer --check_plt --plt .plt -q -r .

clean:
	rm -f ebin/*.beam

FORCE:
