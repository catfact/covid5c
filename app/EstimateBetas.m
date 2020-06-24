% Estimate the beta values.
% Estimate the mu (death rates) values and omegas (hospitalization rates)

% Extract estimated beta and population to get beta_star, the ``base"
% transmission rate.
% Assumes COVID5C_SetParameters has been run so that all parameters are
% defined.
beta_star = beta*TotalPopulation;

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
% Student data from the Google sheet - should be checked
PomonaStudentPop = 1607;
PitzerStudentPop = 1025;
CMCStudentPop = 1254;
ScrippsStudentPop = 990;
HMCStudentPop = 807;
StudentPop = PomonaStudentPop + PitzerStudentPop;  % only use these for now
% Population vector: start with all students non-compliant.
% Since we divide by this vector, make sure all entries are at least one.
if ~exist('propNC','var')
    propNC = .1;
else
    disp(propNC);
    if isEmpty(propNC)
        propNC = .1;
    end
end
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
C_HSC=0.05;                               %Compliant Students to HSC rate
C_LSC=0.5;                                %Compliant Students to LSC rate
NC_HSC=0.1;                               %Non Compliant Students to HSC rate
NC_LSC=1;                                 %Non Compliant Students to LSC rate
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


% RelBetas(10,10) = 10;  % non-compliant to non-compliant
% RelBetas(9,10) = 5;
% RelBetas(1,10) = 3;
% RelBetas(3,10) = 3;
% RelBetas(5,10) = 3;
% RelBetas(7,10) = 3;
% RelBetas(2,10) = 1;
% RelBetas(4,10) = 1;
% RelBetas(6,10) = 1;
% RelBetas(8,10) = 1;
% RelBetas(:,9) = .5; % lower?
% RelBetas(10,9) = 5; 
% Multiply by Beta_Star, and divide by population of the group containing
% the susceptibles, i.e. group j for Beta_{ij}

Betas = RelBetas;

for i =1:length(RelBetas(:,1))
    Betas(:,i) = beta_star*RelBetas(:,i)./pop';
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
muM_vec([9,10]) = muI_student;
%%
omegaH_low = omegaH * low_weight;
omegaH_high = omegaH_low*frac_mu;
omegaH_student= omegaH_low*frac_mu_student;
omegaH_vec = mult;
omegaH_vec([1,2,5,6]) = omegaH_high;
omegaH_vec([3,4,7,8]) = omegaH_low;
omegaH_vec([9,10]) = omegaH_student;
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
n_parameters = 16;
pars = ones(n_parameters,Ngroups);
pars(2,:) = deltaI_vec;
pars(3,:) = deltaM_vec;
pars(4,:) = pars(4,:)*gammaE;
pars(5,:) = pars(5,:)*gammaR;
pars(6,:) = pars(6,:)*kappa;
pars(7,:) = pars(7,:)*Mmax;
pars(8,:) = muI_vec;
pars(9,:) = muM_vec;
pars(10,:) = omegaH_vec;
pars(11,:) = omegaI_vec;
pars(12,:) = pars(12,:)*rhoR;
pars(13,:) = pars(13,:)*rhoS;
pars(14,:) = pars(14,:)*sigma;
pars(15,:) = pars(15,:)*g;
pars(16,:) = pars(16,:)*eta;