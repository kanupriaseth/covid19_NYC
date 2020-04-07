%COVID 19 ANALYSIS, NEW YORK CITY, 2020

close all;
clear all;

% DATES OF AVAILABLE DATA FROM NYC GOVERNMENT WEBSITE
DateStrings = {'2020-03-25';'2020-03-26';'2020-03-27';'2020-03-28';'2020-03-29';'2020-03-30';'2020-03-31';'2020-04-01';'2020-04-02';'2020-04-03';'2020-04-04';'2020-04-05';'2020-04-06'};
date = datetime(DateStrings,'InputFormat','yyyy-MM-dd'); %ALL DATES BETWEEN MAR 25-APR 6
datecasecount = {'2020-03-25';'2020-03-26';'2020-03-27';'2020-03-30';'2020-03-31';'2020-04-01';'2020-04-02';'2020-04-03';'2020-04-04';'2020-04-05';'2020-04-06'};
datecasecount = datetime(datecasecount,'InputFormat','yyyy-MM-dd'); %DATES FOR AVAILABLE DATA (DOESNT INCLUDE MAR 27 & MAR 28)

% AVAILABLE DATA FROM NYC GOVERNMENT WEBSITE
% NO DATA AVAILABLE FOR MARCH 27 AND MARCH 28.
case_count = [20011,23112,26697,38087,41771,45707,49707,56289,60850,64955,68776]; %TOTAL CASE COUNT
deaths = [280,365,450,914,1096,1374,1562,1867,2254,2472,2738]; %NUMBER OF DEATHS
hosp = [3922,4720,5039,7741,8549,9775,10590,11739,12716,14205,15333]; %NUMBER OF HOSPITALIZATIONS

%INTERPOLLATING CASE_COUNT, DEATHS AND HOSPITILATIONS TO GET MISSING VALUE FOR MAR 27 & MAR 28
case_count_int = interp1(datecasecount,case_count,date);
deaths_int = interp1(datecasecount,deaths,date);
hosp_int = interp1(datecasecount,hosp,date);
num_days = length(date);

% MAR 24 TOTAL CASE COUNT DATA TO GET NEW CASES ON MAR 25
% SOURCE https://github.com/nychealth/coronavirus-data/issues/4 & OTHER VALIDATED REPORTING SOURCE
queens= 4364;
bronx = 2328;
brooklyn = 4237;
manhattan = 2887;
staten = 953;
unknown = 7;
total_24 = queens+bronx+brooklyn+manhattan+staten+unknown;
Mar_24_cases = 15597; %based on nyc1 data archive for Mar 28 data, as of 5 pm

%MARCH 28 AND 29 TOTAL CASE COUNT DATA FROM OTHER VALIDATED REPORTING SOURCES
Mar_28_cases = 30765; %based on nyc1 data archive for Mar 28 data, as of 4 pm
Mar_29_cases = 33474; %based on nyc1 data archive for Mar 28 data, as of 4:15 pm

% UPDATING ABOVE DATA WITH NYC GOVT DATA ARCHIVE FOR COMPLETE CASE COUNT B/W MAR 25 AND APR 6
case_count = [20011,23112,26697,30765,33474,38087,41771,45707,49707,56289,60850,64955,68776];

%EDITING NEW CASES COUNT AS PER ABOVE NYC1 DATA ARCHIVE
for num_days = [2:length(date)]
    new_count(num_days) = case_count(num_days)-case_count(num_days-1);
end
new_count(1) = case_count(1)-Mar_24_cases; %New cases on March 25, 2020 in New York City.

%NEW CASES PREDICTED W CURRENT RATE OF SPREAD (based on past 2 days): 
current_rate = ((new_count(11)-new_count(12)) + (new_count(12)-new_count(13)))./2;

%PERCENTAGE INCREASE
for num_days = [2:length(date)]
    ratio_inc(num_days) = (new_count(num_days)./case_count(num_days-1));
    prt_inc = ratio_inc*100; %percentage increase each day
end
prt_inc(1) = 100*(new_count(1)/Mar_24_cases); %percentage increase on Mar 25 

%x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x

%TOTAL CASES & NEW CASES PLOT
subplot(2,1,1);
plot(date,case_count,'ro-');
hold on;
xlabel('Date of diagnosis (updated at 5 pm)');
ylabel('Number of diagnosed cases');
format long;
ylim([20000,70000]);  
yticks([20000:10000:70000]);
yticklabels({'20,000','30,000','40,000','50,000','60,000','70,000'});
title('Evolution of COVID-19 in New York City');
pbaspect([2 1 1]);
%
subplot(2,1,2);
plot(date,new_count,'bo-');
hold on;
xlabel('Date of diagnosis (updated at 5 pm)');
ylabel('Number of new cases diagnosed');
ylim([2500,7500]);  
yticks([2500:1000:7500]);
pbaspect([2 1 1]);
figure;

%DEATHS AND HOSPITILIZATIONS PLOT 
subplot(2,1,1);
plot(date,deaths_int,'ro-');
hold on;
xlabel('Date (updated at 5 pm)');
ylabel('Number of deaths'); 
format long;
ylim([200,3000]);  
yticks([200:400:3000]);
pbaspect([2 1 1]);
subplot(2,1,2);
plot(date,hosp_int,'bo-');
hold on;
xlabel('Date (updated at 5 pm)');
ylabel('Number of hospitilizations');
format long;
ylim([3900,15900]);  
yticks([3900:2000:15900]);
pbaspect([2 1 1]);
figure;

%DOUBLING TIME PLOT
for num_days = [1:length(date)]
    dt(num_days) = (70./prt_inc(num_days)); %doubling-time
end
plot(date,dt,'bo-');
hold on;
xlabel('Date (updated at 5 pm)');
ylabel('Doubling time(days)');
format long;
pbaspect([2 1 1]);
title('Evolution of COVID-19 in New York City');
figure;

%MODEL FOR NEW CASES PREDICTION:
datepred = {'2020-03-25';'2020-03-26';'2020-03-27';'2020-03-28';'2020-03-29';'2020-03-30';'2020-03-31';'2020-04-01';'2020-04-02';'2020-04-03';'2020-04-04';'2020-04-05';'2020-04-06';'2020-04-07';'2020-04-08';'2020-04-09';'2020-04-10';'2020-04-11';'2020-04-12';'2020-04-13';'2020-04-14';'2020-04-15'};
datepred = datetime(datepred,'InputFormat','yyyy-MM-dd');

for x = [1:13]
        casepred(x)=new_count(x); %past data available from 
    end
    for x = [14:22]
        casepred(x)= new_count(13)-((x-13)*current_rate);
    end

% TOTAL NEW CASE PREDICTION 
plot(datepred,casepred,'b-',date,new_count,'ro-','LineWidth',1.25)
hold on;
xlabel('Date of diagnosis (updated at 5 pm)');
ylabel('New cases diagnosed');
legend('Prediction based on past 2-day rate','Actual number of new cases diagnosed','Location','NorthWest','FontSize',8);
format long;
pbaspect([2 1 1]);
title('Evolution of COVID-19 in New York City, 2020');

%NEW COUNT PREDICTION FROM MOST RECENT DATA
for x = [1:13]
    case_countpred(x)=case_count(x); %Existing data for cases per day
end 
for x = [14:22]
    case_countpred(x)=case_countpred(x-1)+casepred(x); %Predicted in terms of number of days from most recent recorded data
end

%RATIO OF DEATHS TO HOSPITALIZATIONS
for x = [1:13]
    ratio_hosp_case(x) = hosp_int(x)./case_countpred(x);
    ratio_death_case(x)= deaths_int(x)./case_countpred(x);
    hosp_case(13) = hosp_int(13);
    deaths_pred(x) = deaths_int(x);
end 
for x = [14:22]
    hosp_case(x) = hosp_case(13) + (ratio_hosp_case(13)*(x-13));
    deaths_pred(x) = (ratio_death_case(13)*(case_countpred(x)));
end

% CASES PREDICTED & DEATHS PREDICTED for next 10 days PLOT
subplot(2,1,1);
plot(datepred,case_countpred,'b-',date,case_count,'ro-','LineWidth',1.25);
hold on;
xlabel('Date of diagnosis (updated at 5 pm)','FontSize',9.5);
ylabel('Total number of diagnosed cases');
format long;
ylim([20000,90000]);  
yticks([20000:10000:90000]);
legend('Predicted using past 2-day rate','Actual number of total diagnosed cases','Location','NorthWest','FontSize',8);
pbaspect([2 1 1]);
title('Evolution of COVID-19 in New York City, 2020');
yticklabels({'20,000','30,000','40,000','50,000','60,000','70,000','80,000','90,000'});

subplot(2,1,2);
plot(datepred,deaths_pred,'b-',date,deaths_int,'ro-','LineWidth',1.25);
hold on;
xlabel('Date of diagnosis (updated at 5 pm)','FontSize',9.5);
ylabel('Number of deaths');
format long;
ylim([200,3600]);  
yticks([200:400:3400]);
legend('Predicted using past 2-day ratio of deaths/total cases','Number of recorded deaths','Location','SouthEast','FontSize',7.92);
pbaspect([2 1 1]);
figure;

% RATIO OF TOTAL DEATHS TO TOTAL CASES COMPARISON (UPDATED: APRIL 6TH, 2020)
china_ratio_death_case = 3371/81740; 
nyc_ratio_death_case = deaths_int(13)./case_count(13); %most recent recorded data- Apr 6th, 2020
italy_ratio_death_case = 17127/135586;