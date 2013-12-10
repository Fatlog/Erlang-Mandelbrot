-module(mandelbrot).
-export([calculate/2, main/0]).

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
	% setup vars
	WIDTH = get(width),
	X = trunc(PIX rem WIDTH),
	Y = trunc(PIX/WIDTH),
	C = get(gbegin),
	{REAL, IMAG} = C,
	{SPANREAL, SPANIMAG} = get(gspan),	
	G = {REAL+X*SPANREAL/(get(width)+1.0),IMAG+Y*SPANIMAG/(get(height)+1.0)},	
		
	% get num iterations
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

	% get the character to output to the screen based on num iterations
	if
		N > 0 -> 
			%I = lists:nth(round(N+1), get(list));
			I = getchar(N+1);
		N =< 0 ->
			I = ''
	end,

	% output the character to the screen
	io:fwrite("~s", [I]),

	% if we are at width then add in a line break
	T = X+1,
	if
		(T) >= WIDTH ->
			io:format("| ~n");
		(T) < WIDTH ->
			io:format("")
	end.

% this function returns the character to display
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

% start point
main() -> 
	put(width, 78),
	put(height, 44),
	NUMPIXELS = get(width) * get(height),
	CENTER = {-0.7, 0},
	SPAN = {2.7, -(4/3.0)*2.7*get(height)/get(width)},
	put(gspan, SPAN),
	put(maxiter, 100000),
	%put(list, ['.','*','c',8,'M','@','j','a','w','r','p','o','g','O','Q','E','P','G','J']),
	
	BEGIN = complex:plus(CENTER, complex:smult(-1/2, SPAN)),
	put(gbegin, BEGIN),
	%END = complex:plus(CENTER, complex:smult(1/2, SPAN)),

	% loop for NUMPIXELS
	for_loop(0, NUMPIXELS, 1, 0).
	%lists:nth(round(20), get(list)).