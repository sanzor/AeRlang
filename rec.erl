-module(rec).
-compile([debug_info]).
-export([dorec/1,dorec/2,take/2,reverse/1,tailZip/2]).

% empty input
dorec(X) when is_list(X)-> dorec([],X);
dorec(_)-> "invalid input".

dorec(Acc,[]) -> Acc;
dorec(Acc,[X|Y])->
    if X rem 2 == 0 -> dorec([X|Acc],Y);
       X rem 2 /=0 -> dorec(Acc,Y)
    end.

dupl(0,_)->[];
dupl(N,Elem) when N>0 -> [N|dupl(N-1,Elem)].

tdup(N,Elem)->tdup(N,Elem,[]).

tdup(0,Elem,Acc)->Acc;
tdup(N,Elem,Acc)->tdup(N-1,Elem,[Elem|Acc]).

take(N,List)->take(N,List,[]).
take(N,[],Acc)->Acc;
take(0,_,Acc)->Acc;
take(N,[H|T],Acc)when N>0->take(N-1,T,[H|Acc]).

reverse([])->[];
reverse([X|XS])->reverse(XS)++[X].


tailZip(L1,L2)->reverse(tailZip(L1,L2,[])).
tailZip([],_,Acc)->Acc;
tailZip(_,[],Acc)->Acc;
tailZip([X|XS],[Y|YS],Acc)->tailZip(XS,YS,[{X,Y}|Acc]).