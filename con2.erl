-module(conc2).
-compile([debug_info]).
-export([initFam/0]).


initFam()->
    Bid=spawn(brother()),
    Bid. %i need to return this Pid back to the caller in order to issue messages !



brother()->
    Sid=spawn(sister,self()),
    link(Sid),
    brotherLoop(Sid).

brotherLoop(Sid)->
    receive   
        kill->Sid ! issue_kill;
        Msg->[Msg|brotherLoop(Sid)]
    end.

sister()->
    receive->
        MSG ->
            {date(),MSG},
             exit(killed_by_bro)
    end.

    
