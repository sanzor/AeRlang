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
        {FROM,done}->ok;
        {FROM,{store,Elem}}->
            FROM ! {self(),stored},
            state([Elem|List]);
        {FROM,{take,Elem}}->
            case lists:member(Elem,List) of
                true -> 
                    FROM ! {self()!,{ok,Elem}},
                    state(lists:delete(Elem,List));
                false->
                    FROM !{self()!,not_found},
                    state(List)
            end
    end.
        
                    

        

