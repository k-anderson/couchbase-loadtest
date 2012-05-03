-module(loadtest_reader).

-export([start/2, exec/2, get/1]).

-include_lib("loadtest/src/loadtest.hrl").

start(Count, Parent) ->
   do_start(Count, Parent),
   io:format("started ~p readers~n", [Count]).

do_start(0, _) -> ok;
do_start(Count, Parent) ->
    exec(Count, Parent),
    do_start(Count - 1, Parent).

exec(Count, Parent) ->
    spawn(fun() -> 
                  try
%%                      Key = binary_to_list(<<"user_", (loadtest_util:to_binary(Count))/binary>>),
                      Key = binary_to_list(<<"user_", (loadtest_util:to_binary(crypto:rand_uniform(1, 1000000)))/binary>>),
                      {Time, _} = timer:tc(?MODULE, get, [Key]),
                      file:write_file(?READER_LOG, io_lib:format("~p~n", [Time]), [append])
                  catch
                      _:_ -> 
                        file:write_file(?READER_LOG, io_lib:format("CRASH~n", []), [append]),
                        ok
                  end,
                  timer:sleep(crypto:rand_uniform(0, 500)),
                  ?MODULE:exec(Count, Parent)
          end).
                   
get(Key) ->
    case loadtest_memcache_pool:getb(Key) of
       {ok, _} -> ok;
       {error, not_found} -> ok
    end.
