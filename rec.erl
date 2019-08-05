-module(rec).
-export([makeFam/0,fatherAndSons/1]).

-record(man,{name,
             age,
             children=[]}).
-record(child,{
    name,
    age,
    sex
}).

makeFam()->
    #man{name="Adrian",
         age=33,
         children=[#child{name="Daniel",age=33,sex="Male"},
                   #child{name="Chris" ,sex="Male"},
                   #child{name="Anne",age=33,sex="Female"}]
        }.


fatherAndSons(Man=#man{children=Ch})->[length(Elem#child.name) || Elem<-Ch,isMale(Elem)].

isMale(#child{sex="Male"})-> true;
isMale(_)->false.

