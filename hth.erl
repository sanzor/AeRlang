-module(hth).
-export([parseData/1]).


main(path)->
    Content=file:read_file(path),
    Data=parse_Data(Content)


parseData(Ls)when is_binary(Ls)->parseData(binary_to_list(Ls));
parseData(Ls)->lists:reverse(parseData([],string:tokens(Ls,"\r\n\t "))).
parseData(Acc,[])->Acc;
parseData(Acc,[H|T])->parseData([list_to_integer(H)|Acc],T).
   