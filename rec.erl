-module(rec).
-export([makeFam/0]).

-record(man,{name,
             age,
             children=[]}).
-record(child,{
    name,
    age,
    sex
}).

makeFam()->
    #man{name="Adrian",age=33,children=[#child{name="A1",age=33,sex="Male"},#child{age=44,sex="Male"}]}.


maleChildren(#man{children=Ch})->[Elem|| Elem<-Ch,isMale(Elem)].
    
isMale(C#child{_,_,Y})->
    case Y of 
        "Male"->true;
         _ ->false
    end.