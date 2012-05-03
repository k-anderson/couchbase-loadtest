-module(loadtest_util).

-export([ensure_started/1]).
-export([current_tstamp/0]).
-export([rand_hex_binary/1]).
-export([to_binary/1]).

ensure_started(App) when is_atom(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok;
        E -> E
    end.

current_tstamp() ->
    calendar:datetime_to_gregorian_seconds(calendar:universal_time()).

rand_hex_binary(Size) when is_integer(Size) andalso Size > 0 ->
    to_hex_binary(crypto:rand_bytes(Size)).

to_hex_binary(S) ->
    Bin = to_binary(S),
    << <<(binary_to_hex_char(B div 16)), (binary_to_hex_char(B rem 16))>> || <<B>> <= Bin>>.

binary_to_hex_char(N) when N < 10 ->
    $0 + N;
binary_to_hex_char(N) when N < 16 ->
    $a - 10 + N.

to_binary(X) when is_float(X) ->
    to_binary(mochinum:digits(X));
to_binary(X) when is_integer(X) ->
    list_to_binary(integer_to_list(X));
to_binary(X) when is_atom(X) ->
    list_to_binary(atom_to_list(X));
to_binary(X) when is_list(X) ->
    iolist_to_binary(X);
to_binary(X) when is_binary(X) ->
    X.


