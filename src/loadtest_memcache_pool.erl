-module(loadtest_memcache_pool).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).
-export([set/2]).
-export([setb/2]).
-export([get/1]).
-export([getb/1]).

-define(SERVER, ?MODULE).
-define(POOL_NAME, memcache_pool).


start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->    
    {ok, PoolConfig} = application:get_env(loadtest, memcache_pool),
    Pool = [{name, {local, ?POOL_NAME}}
            ,{worker_module, loadtest_memcache_worker}
            | PoolConfig
           ],
    {ok, {{one_for_one, 10, 10}, [poolboy:child_spec(?SERVER, Pool)]}}.

set(Key, Value) ->
    poolboy:transaction(?POOL_NAME, fun(Worker) ->
                                            gen_server:call(Worker, {set, Key, Value})
                                    end).

setb(Key, Value) ->
    poolboy:transaction(?POOL_NAME, fun(Worker) ->
                                            gen_server:call(Worker, {setb, Key, term_to_binary(Value)})
                                    end).
get(Key) ->
    poolboy:transaction(?POOL_NAME, fun(Worker) ->
                                            gen_server:call(Worker, {get, Key})
                                    end).

getb(Key) ->
    poolboy:transaction(?POOL_NAME, fun(Worker) ->
                                            gen_server:call(Worker, {getb, Key})
                                    end).
