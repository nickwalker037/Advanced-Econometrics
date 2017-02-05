/* Simulation to illustrate the properties of OLS Estimator (its "Sampling Distribution") */

options ls=78 formdlim ='*' nodate nonumber nolabel;
data samples;
do samp 1 to 10;
do t = 1 to 100;
  u = rannor(1234)*5;
  x = 100 + 3*rannor(5678);
  y = 10 + 0.5*x + u;
  output;
  end;
end;
run;

proc corr;
where samp=1;
var x y u;
run;

proc reg data=samples outest=bvalues outseb;
  by samp;
  model y = x;
  run;

proc print data=bvalues;
run;

data one two;
  set bvalues;
  if _type_='PARMS' then output one;
  else if _type_='SEB' then output two;
  run;
proc print data=one;
proc print data=two;

proc sql;
  create table mystuff
  as select one.intercept as b0hat, one.x as b1hat, two.interceppt as seb0, two.x as seb1
  from one, two
  where one.samp = two.samp;
quit;

proc print data=mystuff;
run;

proc means data=mystuff;
var b0hat b1hat;
run;

proc univariate data=mystuff noprint;
  var b0hat b1hat;
    histogram / normal;
run;
