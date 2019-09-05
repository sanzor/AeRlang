-module(mon).
-compile_flags([debug_info]).
-export([worker/1,init/0,restarter/2]).

% ctrl+g
init()->
    
    Pid=spawn(?MODULE,restarter,[self(),[]]),
    register(restarter,Pid),
    Pid.



restarter(Shell,Queue)->
    process_flag(trap_exit,true),
    
    Wk=spawn_link(?MODULE,worker,[[]]),
    register(worker,Wk),
    
    receive
        
        {'EXIT',Pid,{Queue,normal}}->Shell ! "From res:died peacefully, wont restart";
        {'EXIT',Pid,{Queue,horrible}}->
            Shell ! "will restart in 5 seconds, select fresh/stale -> 1/0",
            receive
                1 -> 
                    Shell ! "Will restart fresh",
                    restarter(Shell,[]);
                0 ->Shell ! "Will continue work",
                    restarter(Shell,Queue)
            after 5000 ->
              Shell ! "No response -> started with 666",
              restarter(Shell,[666]) 
            end;
        {MSG}->Shell ! {"Unknown message...closing",MSG}
end.


worker(Queue)->
    
    receive 

        die->exit({Queue,horrible});
        finish->exit({Queue,normal});
        MSG->[{time(),MSG}|Queue]
end.



