-module(conc).
-compile([debug_info]).
-export([pfunc/0]).

pfunc()->
    receive
        {From,stop} -> From ! "You have send me aa so we are bb";
        {From,X} -> 
            From ! "Thanks for"++X,
            pfunc().
    end.

