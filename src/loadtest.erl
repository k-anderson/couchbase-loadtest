%%%-------------------------------------------------------------------
%%% @copyright (C) 2012, VoIP, INC
%%% @doc
%%%
%%% @end
%%% @contributors
%%%-------------------------------------------------------------------
-module(loadtest).

-export([start_link/0, start/0, stop/0]).

%%--------------------------------------------------------------------
%% @public
%% @doc
%% Starts the app for inclusion in a supervisor tree
%% @end
%%--------------------------------------------------------------------
start_link() ->
    _ = start_deps(),
    loadtest_sup:start_link().

start() ->
    _ = start_deps(),
    application:start(loadtest).    

%%--------------------------------------------------------------------
%% @public
%% @doc
%% Stop the app
%% @end
%%--------------------------------------------------------------------
stop() ->
    application:stop(loadtest).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Ensures that all dependencies for this app are already running
%% @end
%%--------------------------------------------------------------------
start_deps() ->
    _ = [loadtest_util:ensure_started(App) || App <- [sasl, crypto, loadtest_memcache_pool]],
    ok.
