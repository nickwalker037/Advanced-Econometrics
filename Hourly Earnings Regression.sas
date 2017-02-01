options ls=83 formdlim='*' nodate nolabel;
ODS LISTING;


PROC IMPORT OUT=ONE
DATAFILE = "H:\485\Assignment_One_Data.xlsx" replace;
RUN;

PROC CONTENTS; RUN;

DATA TWO;
SET ONE;
lnwage = log(ahe);

proc means data=two;
class = year;
run;

symbol1 i=none c=green v=circle h=.5;

proc reg data=two;
where year=2008;
model ahe = age;
output out=my_hats predicted=ahe_hat residual=u_hat
run;

proc means data=my_hats mean css var;
var ahe ahe_hat u_hat age;
run;

proc corr data=my_hats nosimple;
var ahe ahe_hat u_hat age;
run;

proc reg data=two;
where year=2008;
model lnwage = age female bachelor;
run;
