-module(loadtest_writer).

-export([start/2, exec/2, set/1, test/0]).

-include_lib("loadtest/src/loadtest.hrl").

test() -> ?FSDATA.

start(Count, Parent) ->
   do_start(Count, Parent),
   io:format("started ~p writers~n", [Count]).

do_start(0, _) -> ok;
do_start(Count, Parent) ->
    exec(Count, Parent),
    do_start(Count - 1, Parent).
        
exec(Count, Parent) ->
    spawn(fun() -> 
                  try
%%                      Key = binary_to_list(<<"user_", (loadtest_util:to_binary(Count))/binary>>),
                      Key = binary_to_list(<<"user_", (loadtest_util:to_binary(crypto:rand_uniform(1, 1000000)))/binary>>),
                      {Time, _} = timer:tc(?MODULE, set, [Key]),
                      file:write_file(?WRITER_LOG, io_lib:format("~p~n", [Time]), [append])
                  catch
                      _:_ ->
                        file:write_file(?WRITER_LOG, io_lib:format("CRASH~n", []), [append]),
			ok
                  end,
                  timer:sleep(crypto:rand_uniform(0, 500)),
                  ?MODULE:exec(Count, Parent)
          end).
                   
set(Key) ->
    case crypto:rand_uniform(1, 5) of
        1 -> ok = loadtest_memcache_pool:setb(Key, {crypto:rand_uniform(0, 100)});
        2 -> ok = loadtest_memcache_pool:setb(Key, {crypto:rand_uniform(0, 100), crypto:rand_uniform(0, 100)});
%%        3 -> ok = loadtest_memcache_pool:setb(Key, ?FSDATA);
        3 -> ok = loadtest_memcache_pool:setb(Key, {loadtest_util:rand_hex_binary(crypto:rand_uniform(10, 32))});
        4 -> ok = loadtest_memcache_pool:setb(Key, {loadtest_util:rand_hex_binary(crypto:rand_uniform(5, 10))});
        5 -> ok = loadtest_memcache_pool:setb(Key, {crypto:rand_uniform(0, 100), loadtest_util:rand_hex_binary(crypto:rand_uniform(32, 100))})
    end.
