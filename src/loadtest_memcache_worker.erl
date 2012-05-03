-module(loadtest_memcache_worker).
-behaviour(gen_server).

-export([start_link/1]).
-export([init/1
         ,handle_call/3
         ,handle_cast/2
         ,handle_info/2
         ,terminate/2,
         code_change/3
        ]).

-record(state, {conn}).

start_link(Args) ->
    gen_server:start_link(?MODULE, Args, []).

init(Args) ->    
    Hostname = proplists:get_value(hostname, Args),
    Port = proplists:get_value(port, Args),
    {ok, Conn} = memcached:connect(Hostname, Port),
    {ok, #state{conn=Conn}, 500}.

handle_call({set, Key, Value}, _From, #state{conn=Conn}=State) ->
    {reply, memcached:set(Conn, Key, Value), State, 500};
handle_call({setb, Key, Value}, _From, #state{conn=Conn}=State) ->
    {reply, memcached:setb(Conn, Key, Value), State, 500};
handle_call({get, Key}, _From, #state{conn=Conn}=State) ->
    {reply, memcached:get(Conn, Key), State, 500};
handle_call({getb, Key}, _From, #state{conn=Conn}=State) ->
    {reply, memcached:getb(Conn, Key), State, 500};
handle_call(_Request, _From, State) ->
    {reply, ok, State, 500}.

handle_cast(timeout, #state{conn=Conn}=State) ->
    memcached:version(Conn),
    {noreply, State, 500};
handle_cast(_Msg, State) ->
    {noreply, State, 500}.

handle_info(_Info, State) ->
    {noreply, State, 500}.

terminate(_Reason, #state{conn=Conn}) ->
    ok = memcached:disconnect(Conn),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
