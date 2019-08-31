-module(mon).
-compile_flags([debug_info]).


worker(Queue)->
    receive
        die->exit(died);
        done->exit(Queue,normal);
        MSG->worker([{time(),MSG}|Queue)
end.
start(Shell)->
    {PID,Monitor}->spawn_monitor(?MODULE,worker,[Shell]),
    receive
        {"Exit",_}->spawn_monitor(worker)
         WMSG->Shell ! WMSG
    end.


