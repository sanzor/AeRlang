-module(conc).
-compile([debug_info]).
-export([pfunc/0,state/1]).

pfunc()->
    receive
        {From,stop} -> From ! "You have send me aa so we are bb";
        {From,X} -> 
            From ! "Thanks for"++X,
            pfunc()
    end.

state(List)->
    receive
        {FROM,cut}->FROM ! {self(),terminated};
        {FROM,{add,X}}->
            FROM ! {self(),stored},
            state([X|List]);
        {FROM,{del,X}}->
            case lists:member(X,List) of
                true ->
                    FROM ! {self(),deleted},
                    state(lists:delete(X,List));
                false->
                    FROM ! {self(),not_found},
                    state(List)
end
    end.
        

