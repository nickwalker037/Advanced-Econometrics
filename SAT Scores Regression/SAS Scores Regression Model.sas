/* This code uses linear regression to estimate SAT scores using REXPPP and PERTAKE as dependent variables */
/* REXPPP - represents constant dollars ($ 2014) expenditures per pupil */
/* PERTAKE - represents the percent of graduates taking the SAT */


/* Format the SAS output and import the data: */
options ls=78 formdlim='*'
ods listing;
proc import out=df
datafile = "H:\485\Problem Set 4\sat_newdata08_11.csv" dbms = csv replace; getnames=yes;
run;


/* Create a new dataset where we construct a new variable representing the total SAT score */
data df_two;
set df;

tsat = vsat + msat + wsat;
run;


/* Sort the data and run two separate models using the stacked dataset (4 years of data for 51 states = 204 observations) */
proc sort data = df_two;
by state year;
run;

proc reg data = df_two;
model_1: model tsat = rexppp;
run;

proc reg data = df_two;
model_2: model tsat = rexppp pertake;
run;


/* Means procedure to see if PERTAKE varies over time in our dataset */
proc means data=df_two mean std cv;
class state;
var pertake;
run;


/* Create a new dataset where we construct dummy variables for the states */
data df_three; set df_two; by state;
if FIRST.state THEN j+1;
array D D1-D51;
do over D; I + 1; D=0;
if I=J then D=1; end; i=0;

data df_four;
merge df_two df_three;
by state;

proc print;
run;


/* Run each of the original 2 regressions, now including the dummy variables */
PROC REG data=df_four;
model_3: model tsat = rexppp d1-d50;
run;

PROC REG data=df_four;
model_4: model tsat = rexppp pertake d1-d50;
run;
