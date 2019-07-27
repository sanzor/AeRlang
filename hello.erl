-module(hello).
-compile([debug_info]).
-export([pany/1,dispatch/1,insert/2]).


isList([])->true;
isList([_|_])->true;
isList(_)->false.


pany(X)->
    IsList=isList(X),
    Result=if IsList == true -> "Its a list";
              IsList == false -> dispatch(33)
            end,
    Result.

f()->["Adi","Dan","Razvan"].



dispatch(X) when X>0 ->
    A=if X >3 ->lists:nth(1,f()) ;
       X< 3 -> lists:nth(2,f());
       X==3 -> lists:nth(3,f())
    end,
    B=[{if length(Y) rem 2==0 ->"Ali";1==1->"Alo" end,Y,"Best is still "++A}|| Y <- f()],
    B;

dispatch(_)->"IDF".


insert(X,Set)->
    case lists:member(X,Set) of
        true ->Set;
        false->[X|Set]
    end.





