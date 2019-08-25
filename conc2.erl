-module(conc2).
-compile([debug_info]).
-export([init/0,sis/1,bro/1,broLoop/1]).


init()->
    A=spawn(?MODULE,bro,[self()]),
    A.

bro(Shell)->
    Sis=spawn(?MODULE,sis,[self(),Shell)],
    broLoop([Shell,Sis]).

broLoop([Shell,Sis])->
    receive 
        bro->exit(Sis,ordered_kill);
        MSG->Sis ! MSG,
             Shell ! {"From bro sent to Sis",MSG},
             broLoop([Shell,Sis])
    end.
sis([Bro,Shell])->
    receive
        MSG-> Shell ! {"Thanks Shell,Just received",MSG};
        sis-> Shell ! "I am killing myself soon",
                    exit(killed_myself)

    end.






        