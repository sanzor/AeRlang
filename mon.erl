-module(mon).
-compile_flags([debug_info]).
-export([worker/1,start/1]).

% ctrl+g
init()->
    Pid=spawn(?MODULE,restarter),
    register(Pid,res),
    Pid
end.


restarter(Shell,Queue)->
    Wk=spawn_link(?MODULE,worker,[]),
    register(Wk,worker),
    receive
        {'EXIT',Pid,}
        {'EXIT',Pid,{_,peace}}->Shell ! "From res:died peacefully, wont restart";
        {'EXIT',Pid,{Queue,horrible}}->
            Shell ! "will restart and send current list",
            restarter(Shell,Queue)
        {MSG}->Shell ! {"Unknown msg",MSG}
end.


worker(Queue)->
    receive 
        die->exit()
end.

