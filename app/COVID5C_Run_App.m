% Covid-19 in a college setting - 5Cs
% Written by Maryann Hohn, edited by Ami Radunskaya and Christina Edholm
% Last Edited June 23, 2020
% Modified SEIR model
% % Run the ODEs with i.c.

function [t,y]=COVID5C_Run_App(icATExpHR, icATRecHR,icATExpLR, icATRecLR, ...
                                icStaffExpHR,icStaffRecHR,icStaffExpLR,icStaffRecLR,  icSExpC, icSRecC,icSExpNC, icSRecNC, ...
                                soATHR, soATLR, soStaffHR, soStaffLR,  soSC, soSNC, propNC, scaletracking, incAsymp)
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------
%--Get parameters-------------------------------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------
%run('COVID5C_SetParameters.m')
%run('COVID_LAData.m')
%run('EstimateBetas.m')  

%disp(propNC);

COVID5C_SetParameters;
COVID_LAData;
EstimateBetas;

% Number of States
numOfStates = 13;

% increase infectivity of asympatomatic group
pars(1,:) = incAsymp*pars(1,:);

pars(6,:)=scaletracking*ones(1,10);

%--# of simulation runs--
tmax = 100; % time simulation stops
tspan = [0 tmax];

%-----------------------------------------------------------------------------------------------------------------------------------------------------------------
% --Scale Outside--------------------------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------

pars(13,:)=[soATHR, soATHR, soATLR, soATLR, soStaffHR, soStaffHR, soStaffLR, soStaffLR,  soSC, soSNC] / 7;   
% List order: AdminTeac HR HSC, LSC; LR HSC, LSC;  Staff HR HSC, LSC; LR HSC, LSC; S LR C, S LR NC)

%-----------------------------------------------------------------------------------------------------------------------------------------------------------------
% --Initial conditions--------------------------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------

% List order: AdminTeac HR HSC, LSC; LR HSC, LSC;  Staff HR HSC, LSC; LR HSC, LSC; S LR C, S LR NC)

% Passed variables -- 
% StudentPop = Pomona and Pitzer now
% PercentCompliant = 0;
% FracCompliant = PercentCompliant/100;
% pop = max([StaffPops, FracCompliant*StudentPop , StudentPop*(1-FracCompliant)],ones(1,Ngroups));

% totalPop = sum(pop)

% Proportion in each SEIRMDH group: a vector of 10, one in each category
%  

% List order: A/T HR HSC, LSC; LR HSC, LSC;  H/D/G HR HSC, LSC; LR HSC, LSC; S LR C, S LR NC)
propExp = [icATExpHR,icATExpHR,icATExpLR,icATExpLR,icStaffExpHR,icStaffExpHR,icStaffExpLR,icStaffExpLR,icSExpC,icSExpNC];
propRec = [icATRecHR,icATRecHR,icATRecLR,icATRecLR,icStaffRecHR,icStaffRecHR,icStaffRecLR,icStaffRecLR,icSRecC,icSRecNC]; 

propInf = [      0,        0,     0,    0,       0,         0,     0,    0,    0,      0];  % assumed 0 for all classes at 5C
propMed = [      0,        0,     0,    0,       0,         0,     0,    0,    0,      0];  % assumed 0 for all classes at 5C
propDead = [     0,        0,     0,    0,       0,         0,     0,    0,    0,      0];  % assumed 0 for all classes at 5C
propHeld_S = [     0,        0,     0,    0,       0,         0,     0,    0,    0,      0];  % assumed 0 for all classes at 5C
propHeld_E = [     0,        0,     0,    0,       0,         0,     0,    0,    0,      0];  % assumed 0 for all classes at 5C
propHeld_I = 0; % assumed 0

propSus = 1-propExp - propRec;

% Initalize ic vector
ic = zeros(numOfStates*10+1,1); % 8 states for 10 categories, plus one H_I state

% Divide population into each category
for i=1:10
    j = numOfStates*(i-1);
    % dS/dt
    ic(j+1) = propSus(i)*pop(i);
    % dE/dt
    ic(j+2) = propExp(i)*pop(i);
    % dI/dt
    ic(j+3) = propInf(i)*pop(i);
    % dR/dt
    ic(j+4) = propRec(i)*pop(i);
    % dM/dt
    ic(j+5) = propMed(i)*pop(i);
    % dD/dt
    ic(j+6) = propDead(i)*pop(i);
    % dH_Sdt
    ic(j+7) = propHeld_S(i)*pop(i);
    % dH_Edt
    ic(j+8) = propHeld_E(i)*pop(i);
end

ic(numOfStates*10+1)=propHeld_I*pop(10);

%------------------------------------------------------------------------------------------------------------------------------------------------------------------
% --Run ODE solver-----------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------------------------

[t,y] = ode45(@(t,y) COVID5C_ODE45(t,y,pars, Betas), tspan, ic);

%-----------------------

end
