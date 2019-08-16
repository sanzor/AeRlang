-module(conc).
-compile([debug_info]).
-export([pfunc/0,state/1]).

pfunc()->
    receive
        {FROM,stop} -> FROM ! "You have send me aa so we are bb";
        {FROM,X} -> 
            FROM ! "Thanks for"++X,
            pfunc()
    end.

state(List)->
   receive 
       {FROM,terminate}->FROM !{self(),terminated};
       {FROM,{take,Elem}}->
           case lists:member(Elem,List) of
               true->
                   FROM!{taken,Elem},
                   state(lists:delete(Elem,List));
                false->
                    FROM!{self(),not_found},
                    state(List)
           end;
        {FROM,{store,Elem}}->
                FROM!{self(),added},
                state([Elem|List])
   end.
        
                    

        

