/* Each model regresses additional independent variables against student test scores to see which variable has the most significant impact. Explanations of each of the models are commented above/beside the model name */

options ls=78 formdlim='*'
ods listing;
proc import out=one
datafile= "H:\485\caschool.csv.csv" dbms=csv replace; getnames=yes;
run;

proc contents data=one;
run;
proc means data=one;
run;

symbol1 i=none c=green v=circle h=.5; 	* symbol statement 1;
symbol2 i=none c=red v=dot l=1; 		* symbol statement 2;

/* Model 1 regresses test scores on the student-teacher ratio */
proc reg data=one;
model1: model testscr = str;
plot (testscr predicted.)*str / overlay;
output out=newdat residual= uhat predicted=testscr_hat;
run;

proc reg data=one;
model2: model testscr = str avginc; /* Model 2 adds average income per capita to the model */
model3: model testscr = str avginc meal_pct; /* Model 3 adds a variable that measures the percentage of students who qualify for a reduced price lunch */
model4: model testscr = str avginc meal_pct comp_stu; /* Model 4 adds a variable that measures the number of computers per student */
run;

proc corr data=one;
var testscr str avginc meal_pct comp_stu;
run;

/* Below is code to run a regression using the method of semi-averages, splitting the data into two groups based on size */

proc sort data=one;
by str;
run;

data two;
	set one;
	ob = _n_;
	if ob <= 210 then split=1;
	if ob > 210 then split=2;
	run;
proc means;
	class split;
	var str testscr;
	run;
proc print;
var ob district split str testscr;
run;

/* We then calculated the SSR by hand using the method of semi-averages vs. model 1, and found that the SSR were higher using the method of semi-averages */
