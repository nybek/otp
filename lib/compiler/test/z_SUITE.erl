%%
%% %CopyrightBegin%
%%
%% Copyright Ericsson AB 2015. All Rights Reserved.
%%
%% The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved online at http://www.erlang.org/.
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%%
%% %CopyrightEnd%
%%
-module(z_SUITE).

-export([all/0, suite/0,groups/0,init_per_suite/1, end_per_suite/1,
	 init_per_group/2,end_per_group/2,
	 loaded/1]).

suite() -> [{ct_hooks,[ts_install_cth]}].

all() ->
    test_lib:recompile(?MODULE),
    [loaded].

groups() ->
    [].

init_per_suite(Config) ->
    Config.

end_per_suite(_Config) ->
    ok.

init_per_group(_GroupName, Config) ->
    Config.

end_per_group(_GroupName, Config) ->
    Config.

loaded(_Config) ->
    0 = do_loaded(code:all_loaded(), 0),
    ok.

do_loaded([{M,_}|Ms], E0) ->
    E = try
	    _ = M:module_info(),
	    _ = M:module_info(functions),
	    E0
	catch
	    C:Error ->
		Stk = erlang:get_stacktrace(),
		io:format("~p:~p\n~p\n", [C,Error,Stk]),
		E0 + 1
	end,
    do_loaded(Ms, E);
do_loaded([], E) -> E.