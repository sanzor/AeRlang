-module(mon).
-compile_flags([debug_info]).
-export([worker/1,start/1]).

% ctrl+g
worker(Queue)->
    receive
        die->exit(died);
        gather->exit({Queue,normal});
        MSG->worker([{time(),MSG}|Queue])
end.
start(Shell)->
    {PID,Monitor}=spawn_monitor(?MODULE,worker,[Shell]),
    receive
        {"EXIT",_,Data}->
            Shell ! {"Restart worker, data so far:",element(2,Data)},
            spawn_monitor(worker);
         WMSG->Shell ! WMSG
    end.


