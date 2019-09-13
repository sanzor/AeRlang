-module(mon).
-compile_flags([debug_info]).
-export([worker/1,init/0,restarter/2,clean/1,send/2]).

% ctrl+g
init()->
    Wk=whereis(aa),
    Pid=spawn(?MODULE,restarter,[self(),[]]),
    register(restarter,Pid),
    Pid.

send(Atom,Message)when is_atom(Atom)->
    case whereis(Atom) of
        undefined -> error("There is no process with the target id");
        PID -> PID ! Message
end.    
clean(List)->
    lists:map(fun(X)->
        Var=whereis(X),
        if Var/=undefined ->
            exit(Var,normal) ;
            true -> io:format("nada")
        end
        end
        ,List).

restarter(Shell,LeftOver)->
    process_flag(trap_exit,true),
    
    Wk=spawn_link(?MODULE,worker,[LeftOver]),
    register(worker,Wk),
    
    receive
        
        {'EXIT',Pid,{Queue,normal}}->Shell ! {Queue,"From res: worker died peacefully, wont restart"};
                                    
        {'EXIT',Pid,{Queue,horrible}} ->
                Shell ! {Queue,"Processed so far:"},
                Shell ! "will restart in 5 seconds, select fresh/stale -> 1/0",
            receive
                1 -> 
                    Shell ! "Will restart fresh",
                    restarter(Shell,[]);
                0 ->Shell ! "Will continue work",
                    restarter(Shell,Queue)
            after 1000000 ->
              Shell ! "No response -> started with 666",
              restarter(Shell,[666]) 
            end;

        MSG->Shell ! {"Unknown message...closing",MSG}
end.


worker(Results)->
    
   
    receive 
        die->exit({Results,horrible});
        finish->exit({Results,normal});
        MSG->worker([{time(),MSG}|Results])
    end.


rec2(Shell)->
    receive
        MSG->
            receive
             DAT-> Shell ! MSG ! DAT
end
end.






