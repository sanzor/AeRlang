-module(conc).
-compile([debug_info]).
-export([pfunc/0,fridge/1,start/1,take/2,store/2]).

pfunc()->
    receive
        {FROM,stop} -> FROM ! "You have send me aa so we are bb";
        {FROM,X} -> 
            FROM ! "Thanks for"++X,
            pfunc()
    end.

fridge(List)->
    receive 
        {FROM,{take,Elem}}->
           case lists:member(Elem,List) of
               true->
                   FROM !{self(),{taken,Elem}},
                   fridge(lists:delete(Elem,List));
                false->
                    FROM !{self(),{not_found}},
                    fridge(List)
           end;
        {FROM,{store,Elem}}->
            FROM !{self(),{stored,Elem}},
            fridge([Elem|List]);
        {FROM,terminate}->FROM !{self(),terminated}
    end.

start(List)->
    spawn(?MODULE,fridge,[List]).
take(PID,Elem)->
    PID!{self(),{take,Elem}},
    receive
        {Pid,MSG}->MSG
    after 3000 -> timeout
    end.

store(PID,Elem)->
    PID!{self(),{store,Elem}},
    receive
        {Pid,MSG}->MSG
after 3000 ->
          timeout
    end.
stop(PID)->
    PID!{self(),terminate}.



del(DELAY)->
    receive
        {FROM,MSG}->FROM ! {in_time}
    after DELAY ->
        FROM!{timeout,msg}
    end.



     