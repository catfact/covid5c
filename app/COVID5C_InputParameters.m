function [pop,Betas, RelBetas, pars]=COVID5C_InputParameters(soATHR, soATLR, soStaffHR, soStaffLR,  soSC, soSNC, propNC, scaletracking, incAsymp,scale_beta)

%% Set parameters for single class COVID model using LA County Data

%1 - overwritten incAsymp
%alpha=  .75;
%2 susc to exp
beta =  2.2625e-09; 
%3 inf to rec
deltaI = 0.081961233707576;
%4 med/quar to rec
deltaM =   0.0129;
%5 exp to infected 
gammaE =  .0081; 
%6 exp to recovered
gammaR =  0.039640136674653; 
%7 tracing effectiveness (between 0 and 1) -- overwritten scaletracking
%kappa = 0; 
%8 Max hospital capacity parameter (this is the "leveling off" value from the data)
Mmax =  2089; 
%9 inf to dead
muI =    1.32e-05;
%10 med/quar to dead
muM =  .0115; 
%11 inf to med/quar
omegaI =   0.0146; 
%12 held to susc
rhoS = 1/14;
%13 contacts per infected person per day
sigma = 10; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% LA County Data - June 13, 2020 through June 30, 2020
% ConfCase = [74123,74717,76679,78486,80574,82623,84549,86072,86934,89210,91562,93959,96641,99008,100526,101070,101768,101945];
% Deaths = [2833,2857,2886,2909,2946,2968,3001,3030,3053,3075,3090,3119,3138,3154,3170,3191,3210,3224];
% Hpatient_rev = [2538, 2511, 2465, 2316, 2296, 2237, 2283, 2259, 2090, 2001, 1969, 1920, 1900, 1958, 1947, 1956, 1797, 1768];
% Hpatient = fliplr(Hpatient_rev);
% ten_dayCum = 13615;
% CumTo10DayStart = 60508;
%Total Population considered for outbreak
    TotalPopulation = 9651332; 
% Find factors to scale parameters in the 
% low (< 65)  versus high-risk  (>=65) age groups
% The affected parameters are omega_I, omega_H, mu_I, mu_H, delta_I,
% delta_M 
% These numbers are from the LA County public health website, July 4, 2020
pop_old  = 1172554;  % over 65
pop_mid = 3149516; % 41 to 65
pop_younger  = 3232266; % 18 to 40
pop_young = pop_mid + pop_younger;
cases_old = 13728;
cases_mid = 37287;
cases_younger = 42983; % 18 to 40
% cases_youngest = 7972; % < 18
cases_young = cases_mid+cases_younger;
deaths_old = 2436;
deaths_mid = 698;
deaths_younger = 94;
deaths_young = deaths_mid + deaths_younger;
frac_mu = (deaths_old/cases_old)/(deaths_young/cases_young);
% PREVIOUSLY %%%%%%%%%%
% Assume that the hospitalization (omega) and  death (mu)  rate for
% college-age students is .1* rate for <65 population.
% UPDATED %%%%%%%%%
% using 18 to 40 versus 40 to 65
frac_mu_student = (deaths_younger/cases_younger)/(deaths_mid/cases_mid);

% for the length of hospital stay, used LA County data, see
% RacialEthnicSocioeconomicDataCOVID19, through April 12
pop_low = 227;
stay_length_low = 5.04;
pop_high = 70;
stay_length_high = 6.60;
total_pop_hosp = pop_low + pop_high;
frac_delta = stay_length_low/stay_length_high;
% using data from LA County for length of hospital stay
stay_length_student = 2;
frac_delta_student  =  stay_length_low/stay_length_student;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Estimate the beta values.
% Estimate the mu (death rates) values and omegas (hospitalization rates)

% Extract estimated beta and population to get beta_star, the ``base"
% transmission rate.
% Assumes COVID5C_SetParameters has been run so that all parameters are
% defined.
beta_star = beta*TotalPopulation;

beta_star=scale_beta*beta_star;
%% Number the different communities:


% 1 : Teaching/Admin High Risk, High Student Contact
% 2 : Teaching/Admin High Risk, Low Student Contact
% 3 : Teaching/Admin Low Risk, High Student Contact
% 4 : Teaching/Admin Low Risk, Low Student Contact
% 5 : Staff (Housekeeping/Dining/Grounds)  High Risk, High Student Contact
% 6 : Staff (Housekeeping/Dining/Grounds) High Risk, Low Student Contact
% 7 : Staff (Housekeeping/Dining/Grounds) Low Risk, High Student Contact
% 8 : Staff (Housekeeping/Dining/Grounds) Low Risk, Low Student Contact
% 9 : Compliant students
% 10 : Non-compliant students
Ngroups = 10;
%% Beta values: beta_pq is transmission from community p to community q
%
%  Calculated as beta_star/pop(community)*multiple_qp
%  Population of each commumity 
%  Using Pomona + Pitzer - May 29, 2020 - see Excel file "FiveCData"
% order is as above:  TA-HR-HC,  TA-HR-LC, TA-LR-HC, TA-LR-LC, 
%                     D/H/G-HR-HC,  D/H/G-HR-LC, D/H/G-LR-HC, D/H/G-LR-LC
StaffPops = [88,  24, 693, 371, 8,  12, 73, 166]; 
admin_pop = StaffPops(1:4);
staff_pop = StaffPops(5:8);

% Student data from the Google sheet - should be checked
PomonaStudentPop = 1607;
PitzerStudentPop = 1025;
% CMCStudentPop = 1254;
% ScrippsStudentPop = 990;
% HMCStudentPop = 807;
StudentPop = PomonaStudentPop + PitzerStudentPop;  % only use these for now
% Population vector: start with all students non-compliant.
% Since we divide by this vector, make sure all entries are at least one.
%if ~exist('propNC','var')
%    propNC = .1;
%end
FracCompliant = 1-propNC;  % argument to COVID5C_Run

pop = max([StaffPops, FracCompliant*StudentPop , StudentPop*(1-FracCompliant)],ones(1,Ngroups));

% Start with relative beta values: relative to beta_star which was
% estimated from the LA Data
% RelBetas(i,j) is the beta FROM group i infected TO group j, susceptibles.
basevalue=0.1;
AT_HRtoHR=0.1;                            %AdminTeach the HR to HR rate
St_HRtoHR=0.1;                            %Staff the HR to HR rate
AT_LRtoLR=0.25;                           %AdminTeach the LR to LR rate
St_LRtoLR=0.25;                           %Staff the LR to LR rate
AT_St_LR=0.15;                            %AdminTeach to the Staff all LR rate
St_AT_LR=0.15;                            %Staff to the AdminTeach all LR rate
HR_HSC_S=0.05;                            %AdminTeach and Staff HR_HSC to Students rate
HR_LSC_S=0.01;                            %AdminTeach and Staff HR_LSC to Students rate
LR_HSC_S=0.15;                            %AdminTeach and Staff LR_HSC to Students rate
LR_LSC_S=0.01;                            %AdminTeach and Staff LR_LSC to Students rate
C_HSC=0.5;                               %Compliant Students to HSC rate
C_LSC=0.05;                                %Compliant Students to LSC rate
NC_HSC=1;                               %Non Compliant Students to HSC rate
NC_LSC=0.1;                                 %Non Compliant Students to LSC rate
C_C=0.75;                                 %Compliant Students to Compliant Students rate
C_NC=1.25;                                %Compliant Students to Non Compliant Students rate
NC_C=1.25;                                %Non Compliant Students to Compliant Students rate
NC_NC=2;                                  %Non Compliant Students to Non Compliant Students rate


RelBetas = basevalue*ones(Ngroups,Ngroups);  % smallest level - make smaller?

RelBetas(1,1)=AT_HRtoHR; RelBetas(2,1)=AT_HRtoHR; RelBetas(1,2)=AT_HRtoHR; RelBetas(2,2)=AT_HRtoHR;

RelBetas(5,5)=St_HRtoHR; RelBetas(6,5)=St_HRtoHR; RelBetas(5,6)=St_HRtoHR; RelBetas(6,6)=St_HRtoHR;

RelBetas(3,3)=AT_LRtoLR; RelBetas(4,3)=AT_LRtoLR; RelBetas(3,4)=AT_LRtoLR; RelBetas(4,4)=AT_LRtoLR;

RelBetas(7,7)=St_LRtoLR; RelBetas(8,7)=St_LRtoLR; RelBetas(7,8)=St_LRtoLR; RelBetas(8,8)=St_LRtoLR;

RelBetas(7,3)=AT_St_LR; RelBetas(8,3)=AT_St_LR; RelBetas(7,4)=AT_St_LR; RelBetas(8,4)=AT_St_LR;

RelBetas(3,7)=St_AT_LR; RelBetas(3,8)=St_AT_LR; RelBetas(4,7)=St_AT_LR; RelBetas(4,8)=St_AT_LR;

RelBetas(9,1)=HR_HSC_S; RelBetas(9,5)=HR_HSC_S; RelBetas(10,1)=HR_HSC_S; RelBetas(10,5)=HR_HSC_S;

RelBetas(9,2)=HR_LSC_S; RelBetas(9,6)=HR_LSC_S; RelBetas(10,2)=HR_LSC_S; RelBetas(10,6)=HR_LSC_S;

RelBetas(9,3)=LR_HSC_S; RelBetas(9,7)=LR_HSC_S; RelBetas(10,3)=LR_HSC_S; RelBetas(10,7)=LR_HSC_S;

RelBetas(9,4)=LR_LSC_S; RelBetas(9,8)=LR_LSC_S; RelBetas(10,4)=LR_LSC_S; RelBetas(10,8)=LR_LSC_S;

RelBetas(1,9)=C_HSC; RelBetas(3,9)=C_HSC; RelBetas(5,9)=C_HSC; RelBetas(7,9)=C_HSC;

RelBetas(2,9)=C_LSC; RelBetas(4,9)=C_LSC; RelBetas(6,9)=C_LSC; RelBetas(8,9)=C_LSC;

RelBetas(1,10)=NC_HSC; RelBetas(3,10)=NC_HSC; RelBetas(5,10)=NC_HSC; RelBetas(7,10)=NC_HSC;

RelBetas(2,10)=NC_LSC; RelBetas(4,10)=NC_LSC; RelBetas(6,10)=NC_LSC; RelBetas(8,10)=NC_LSC;

RelBetas(9,9)=C_C; RelBetas(10,9)=C_NC; RelBetas(9,10)=NC_C; RelBetas(10,10)=NC_NC;

% Multiply by Beta_Star, and divide by population of the group containing
% the susceptibles, i.e. group j for Beta_{ij}

Betas = basevalue*ones(Ngroups,Ngroups);

% Betas divide by their larger class (e.g. admin/teach and staff)
for i = 1:4
    Betas(:,i) = beta_star*RelBetas(:,i)/sum(admin_pop);
    Betas(:,i+4) = beta_star*RelBetas(:,i+4)/sum(staff_pop);
end
% Betas divide by their larger class (students)
for i = 9:10
    Betas(:,i) = beta_star*RelBetas(:,i)/StudentPop;
end

% Find age-dependent parameters
% Calculate relative rate for the mus and omegas
% frac_mu = (deaths_old/cases_old) / (deaths_young/cases_young)
mult = ones(1,Ngroups);  % vector of ones as base multiplier for parameters
low_weight = TotalPopulation/(pop_young + pop_old*frac_mu);
%%
muI_low = muI * low_weight;
muI_high = muI_low*frac_mu;
muI_student= muI_low*frac_mu_student;
muI_vec = mult;
muI_vec([1,2,5,6]) = muI_high;
muI_vec([3,4,7,8]) = muI_low;
muI_vec([9,10]) = muI_student;
%%
muM_low = muM * low_weight;
muM_high = muM_low*frac_mu;
muM_student= muM_low*frac_mu_student;
muM_vec = mult;
muM_vec([1,2,5,6]) = muM_high;
muM_vec([3,4,7,8]) = muM_low;
muM_vec([9,10]) = muM_student;
%%
% omegaH_low = omegaH * low_weight;
% omegaH_high = omegaH_low*frac_mu;
% omegaH_student= omegaH_low*frac_mu_student;
% omegaH_vec = mult;
% omegaH_vec([1,2,5,6]) = omegaH_high;
% omegaH_vec([3,4,7,8]) = omegaH_low;
% omegaH_vec([9,10]) = omegaH_student;
%%
omegaI_low = omegaI * low_weight;
omegaI_high = omegaI_low*frac_mu;
omegaI_student= omegaI_low*frac_mu_student;
omegaI_vec = mult;
omegaI_vec([1,2,5,6]) = omegaI_high;
omegaI_vec([3,4,7,8]) = omegaI_low;
omegaI_vec([9,10]) = omegaI_student;
%%
low_weight_delta = total_pop_hosp/(pop_low + frac_delta*pop_high);
deltaI_low = deltaI*low_weight_delta;
deltaI_high = deltaI_low*frac_delta;
deltaI_student= deltaI_low*frac_delta_student;
deltaI_vec = mult;
deltaI_vec([1,2,5,6]) = deltaI_high;
deltaI_vec([3,4,7,8]) = deltaI_low;
deltaI_vec([9,10]) = deltaI_student;
%%
deltaM_low = deltaM*low_weight_delta;
deltaM_high = deltaM_low*frac_delta;
deltaM_student= deltaM_low*frac_delta_student;
deltaM_vec = mult;
deltaM_vec([1,2,5,6]) = deltaM_high;
deltaM_vec([3,4,7,8]) = deltaM_low;
deltaM_vec([9,10]) = deltaM_student;
%% Make a matrix of parameters values, one row for each parameter.  Beta values is its own matrix, Betas
n_parameters = 13;
pars = ones(n_parameters,Ngroups);
pars(1,:) = pars(1,:)*incAsymp;
pars(2,:) = deltaI_vec;
pars(3,:) = deltaM_vec;
pars(4,:) = pars(4,:)*gammaE;
pars(5,:) = pars(5,:)*gammaR;
pars(6,:) = pars(6,:)*scaletracking;
pars(7,:) = pars(7,:)*Mmax;
pars(8,:) = muI_vec;
pars(9,:) = muM_vec;
pars(10,:) = omegaI_vec;
pars(11,:) = pars(11,:)*rhoS;
pars(12,:) = pars(12,:)*sigma;
pars(13,:)=[soATHR, soATHR, soATLR, soATLR, soStaffHR, soStaffHR, soStaffLR, soStaffLR,  soSC, soSNC] / 7;   
% List order: AdminTeac HR HSC, LSC; LR HSC, LSC;  Staff HR HSC, LSC; LR HSC, LSC; S LR C, S LR NC)
