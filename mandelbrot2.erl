-module(mandelbrot2).
-export([calculate/2, main/0, start/4]).

calculate({X, Y}, K) ->
	put(c, {X, Y}),
	%put(z, {X, Y}),
	put(totaliter, K),
	go({X, Y}).

go({X, Y}) -> 
	go(0, {X, Y}).

go(1000, {X, Y}) ->
	%io:format("Max Reached ~p ~n", [get(totaliter)]);
	"";

go(I, {X, Y}) ->
	% keep updating totaliter
	put(totaliter, I), 

	% get complex:abs
	K = complex:abs({X, Y}), 
	
	% if complex:abs >= 2.0 then break else keep looping
	if
		K >= 2.0 ->			
			% end loop
			go(1000, {X, Y});
		K < 2.0 ->
			Z = complex:plus(complex:mult({X, Y}, {X, Y}), get(c)),
			go(I+1, Z)
	end.

for_loop(N, Length, _Inc, Acc) when N >= Length -> 
    io:format("Done!~n"); 

for_loop(N, Length, Inc, Acc) ->	
    for_loop(N+Inc, Length, Inc, [generate(N)]).

generate(PIX) ->
	WIDTH = get(width),
	X = trunc(PIX rem WIDTH),
	Y = trunc(PIX/WIDTH),
	C = get(gbegin),
	{REAL, IMAG} = C,
	{SPANREAL, SPANIMAG} = get(gspan),
	G = {REAL+X*SPANREAL/(get(width)+1.0),IMAG+Y*SPANIMAG/(get(height)+1.0)},	
		
	% get maxiter
	MAXITER = get(maxiter),
	calculate(G, MAXITER),
	N = get(totaliter),
	if
		N == MAXITER -> 
			N = 0;
		N < MAXITER -> 
			N = N;
		N > MAXITER ->
			N = 0
	end,	

	% get character to display
	if
		N > 0 -> 
			%I = lists:nth(round(N+1), get(list));
			I = getchar(N+1);
		N =< 0 ->
			I = ''
	end,

	% get list
	L = get(list),
	
	% add character to list
	NEWLIST = lists:append(L, I),

	% put list
	put(list, [NEWLIST]).	

getchar(N) ->
	L = N rem 20,
	if
		L < 1 -> ' ';
		L == 1 -> '.';
		L == 2 -> ',';
		L == 3 -> 'c';
		L == 4 -> '8';
		L == 5 -> 'M';
		L == 6 -> '@';
		L == 7 -> 'j';
		L == 8 -> 'a';
		L == 9 -> 'w';
		L == 10 -> 'r';
		L == 11 -> 'p';
		L == 12 -> 'o';
		L == 13 -> 'g';
		L == 14 -> 'O';
		L == 15 -> 'Q';
		L == 16 -> 'E';
		L == 17 -> 'P';
		L == 18 -> 'G';
		L == 19 -> 'J';
		L > 19 -> ' '
	end.

main() ->
	WIDTH = 78,
	HEIGHT = 44,
	NUMPIXELS = WIDTH * HEIGHT,
	J = NUMPIXELS/2,
	io:format("J is ~p ~n", [J]),

	% spawn processes giving each process a portion of the work
	spawn(mandelbrot2, start, [WIDTH, HEIGHT, 0, NUMPIXELS/2]),
	spawn(mandelbrot2, start, [WIDTH, HEIGHT, 1717, NUMPIXELS]).

start(Width, Height, Start, End) -> 
	put(width, Width),
	put(height, Height),	
	CENTER = {-0.7, 0},
	SPAN = {2.7, -(4/3.0)*2.7*get(height)/get(width)},
	put(gspan, SPAN),
	put(maxiter, 100000),

	% setup list for characters
	put(list, []),

	BEGIN = complex:plus(CENTER, complex:smult(-1/2, SPAN)),
	put(gbegin, BEGIN),
	%END = complex:plus(CENTER, complex:smult(1/2, SPAN)),

	% loop for NUMPIXELS
	for_loop(Start, End, 1, 0).
	%lists:nth(round(20), get(list)).