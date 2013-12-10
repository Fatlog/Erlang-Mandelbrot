-module(complex).
-export([mult/2, plus/2, abs/1, smult/2]).

mult({I, J}, {X, Y}) -> 
  	{I*X - J*Y, I*Y + J*X}.

plus({I, J}, {X, Y}) -> 
	{I+X, J+Y}.

abs({X, Y}) ->
	%io:format("ComplexABS: ~p ~p ~n", [X,Y]),
	%io:format("SQRT Of: ~p ~n", [X*X - Y*Y]),
	TEMP = (X*X-Y*Y),
	if
		TEMP > 0 ->
			%io:format(" Is ~p ~n", [math:sqrt(X*X - Y*Y)]),
			math:sqrt(X*X - Y*Y);
		TEMP < 0 ->
			%io:format("NAN ~n", []),
			math:sqrt(1)
	end.

smult(K, {X, Y}) ->
	{K*X, K*Y}.