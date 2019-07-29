-module(err).
-compile([debug_info]).
-export([thro/1,th/1,f/0,hasvalue/2,hasval/2,get/0]).


thro(F)->
    try F() of 
        _ -> {ok}
    catch
    error:Error -> {"Some error",Error};
    throw:44 ->{"Thew 44"};
    throw:_ ->"Some shabby throw";
    exit:Code ->{exit, Code}
end.

th(F)->try F() of 
    _ -> {ok} 
    catch
        
        error:_ -> {ok};
        E:R->{E,R};
        exit:_ -> {asasa}
end.
% th(F)->
%     try
%         A=2,
%         B=A+1,
%         F(B)
%     of
%       Exception:Reason -> {err,Exception,Reason}
%     end.

f()->44.

hasvalue(Val,{node,'nil'})->false;
hasvalue(Val,{node,{_,Val,_,_}})->true;
hasvalue(Val,{node,{_,_,Left,Right}})->
    case hasvalue(Val,Left) of 
        true-> true;
        false->hasvalue(Val,Right)
end.

hasval(Val,Node)->
    try
        hasval1(Val,Node) 
    of
      false->false
catch
    true->true
end.

hasval1(Val,{node,'nil'})->false;
hasval1(Val,{node,{_,Val,_,_}})->throw(true);
hasval1(Val,{node,{_,_,S,B}})->
    hasval1(Val,S),
    hasval1(Val,B).
      
get()->
    {node,{11,22,
                {node,{33,44,{node,'nil'},{node,'nil'}}},
                {node,'nil'}
          }
    }.