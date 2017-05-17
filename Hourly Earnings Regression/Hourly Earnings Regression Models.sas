/* Multiple simple linear regression models using age, gender, and education to predict average hourly earnings*/
/* AHE = average hourly earnings */




options ls=83 formdlim='*' nodate nolabel;
ODS LISTING;


PROC IMPORT OUT=ONE
DATAFILE = "H:\485\Hourly_Earnings_Data.xlsx" replace;
RUN;

PROC CONTENTS; RUN;

/* Create a new dataset to construct a variable for the log of average hourly earningse */
DATA TWO;
SET ONE;
lnwage = log(ahe);

proc means data=two;
class = year;
run;

/* format the plots */
symbol1 i=none c=green v=circle h=.5;


/* run the regressions, and output the predicted values into a serparate dataset so we could verify the assumptions in our OLS model */
proc reg data=two;
where year=2008;
model ahe = age;
output out=my_hats predicted=ahe_hat residual=u_hat
run;

proc means data=my_hats mean css var;
var ahe ahe_hat u_hat age;
run;

/* Run a correlation matrix to verify our OLS assumptions */
proc corr data=my_hats nosimple;
var ahe ahe_hat u_hat age;
run;

/* Run a regression using the log of wage as our independent variable, and including all 3 of our independent variables */
proc reg data=two;
where year=2008;
model lnwage = age female bachelor;
run;
