-module(rpn).
-export([rpn/1]).

rpn(L) when is_list(L)->
    [Res]=lists:foldl(fun rpn/2 ,[],string:tokens(L," ")),
    Res.


rpn("+",[N1,N2|L])->[N1+N2|L];
rpn("-",[N1,N2|L])->[N1-N2|L];
rpn("*",[N1,N2|L])->[N1*N2|L];
rpn("/",[N1,N2|L])->[N1/N2|L];
rpn("ln",[N|L])->[math:log(N)|L];
rpn(X,Stack)->[read(X)|Stack].


read(N) ->
case string:to_float(N) of
{error,no_float} -> list_to_integer(N);
{F,_} -> F
end.

rpntesT()->
    7=rpn("3 4 +"),
    80=rpn(15 5 + 4 *),
    