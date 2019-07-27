-module(higherOrder).
-export([map/2,shadow/1,hiding/0,filter/2,max/1,custFold/3]).
-compile([debug_info]).


map(F,L)->map(F,L,[]).
map(F,[],Acc)->Acc;
map(F,[H|T],Acc)->map(F,T,[(fun(X)->F(X)+1 end)(H)|Acc]).

shadow(X)->T=fun()->X()+2 end,T .


hiding()->A=33,(fun()->A=44 end),A.


filter(P,L)->filter(P,L,[]).
filter(_,[],Acc)->Acc;
filter(P,[H|T],Acc)->
    case P(H) of
       true-> filter(P,T,[H|Acc]);
       false -> filter(P,T,Acc)
    end.

max([X|XS])->max(X,XS).
max(X,[])->X;
max(X,[H|T])when H>X -> max(H,T);
max(X,[H|T])->max(X,T).

custFold(_,Start,[])->Start;
custFold(F,Start,[H|T])->custFold(F,F(H,Start),T).