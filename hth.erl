-module(hth).
-export([parseData/1,group/2,group2/2]).


main(path)->
    Content=file:read_file(path),
    Data=parseData(Content).
    

parseData(Ls)when is_binary(Ls)->parseData(binary_to_list(Ls));
parseData(Ls)->
    Tokens=[list_to_integer(T)|| T<-string:tokens(Ls,"\r\n\t ")],
    group([],Tokens).


group(Acc,[X,Y,Z|T])->group([{X,Y,Z}|Acc],T);
group(Acc,_)->Acc.

group2([], Acc) ->Acc;
group2([A,B,X|Rest], Acc) -> group2(Rest, [{A,B,X} | Acc]).

shortStep({A,B,X},{{DistA,PathA},{DistB,PathB}})->
    OptA1={DistA+A,[{a,A}|PathA]},
    OptA2={DistB+B+X,[{x,X},{b,B}|PathB]},
    OptB1={DistB+B,[{b,B}|PathB]},
    OptB2={DistA+A+X,[{x,X},{a,A}|PathA]},
    {min(OptA1,OptA2),min(OptB1,OptB2)}.

optimal_path(Map) ->
            {A,B} = lists:foldl(fun shortest_step/2, {{0,[]}, {0,[]}}, Map),
            {_Dist,Path} = if hd(element(2,A)) =/= {x,0} -> A;
            hd(element(2,B)) =/= {x,0} -> B
            end,
            lists:reverse(Path).
